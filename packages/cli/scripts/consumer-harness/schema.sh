#!/bin/sh
# Offline validator for the deliberately bounded vocabulary in the bundled schemas.
# This is not a general JSON Schema implementation. Unsupported assertions fail closed.
set -eu
[ "$#" -eq 2 ] || { printf 'usage: schema.sh SCHEMA DATA\n' >&2; exit 2; }
schema=$1
data=$2
command -v jq >/dev/null 2>&1 || { printf 'schema: jq 1.7 or newer is required\n' >&2; exit 2; }
for file in "$schema" "$data"; do
  [ -f "$file" ] && [ ! -L "$file" ] || { printf '%s: expected a regular non-symlink file\n' "$file" >&2; exit 1; }
  [ "$(wc -c <"$file")" -le 1048576 ] || { printf '%s: exceeds the 1 MiB contract limit\n' "$file" >&2; exit 1; }
  # A streaming close event closes its parent. Track completed paths to detect
  # repeated object members, including duplicate containers with disjoint children.
  if ! jq --stream -n -e '
    reduce inputs as $e ({closed:{}, count:0};
      .count += 1 |
      if .count > 20000 or ($e[0]|length) > 32 then error("JSON complexity limit exceeded") else . end |
      if ($e|length)==2 then
        $e[0] as $p |
        .closed as $closed |
        if any(range(0;($p|length)+1); ($p[0:.]|tojson) as $key | $closed[$key] == true)
        then error("duplicate JSON member at " + ($p|tojson)) else . end |
        .closed[($p|tojson)] = true
      else .closed[($e[0][0:-1]|tojson)] = true end
    ) | true' "$file" >/dev/null; then
    printf '%s: malformed, duplicate, or oversized JSON\n' "$file" >&2
    exit 1
  fi
  jq -s -e 'length == 1 and (.[0]|type == "object")' "$file" >/dev/null || {
    printf '%s: exactly one JSON object is required\n' "$file" >&2; exit 1;
  }
done
if ! jq -n -e --slurpfile schema "$schema" --slurpfile data "$data" '
 def allowed: ["$schema","$id","$comment","title","description","$defs","$ref","type","const","enum","required","properties","additionalProperties","propertyNames","minProperties","maxProperties","items","minItems","maxItems","uniqueItems","minLength","maxLength","pattern","minimum","maximum","allOf","anyOf","oneOf","not"];
 def compile($s):
   if ($s|type)=="boolean" then true
   elif ($s|type)!="object" then error("schema must be an object or boolean")
   elif (($s|keys)-allowed|length)>0 then error("unsupported schema vocabulary: "+((($s|keys)-allowed)|join(",")))
   elif ($s|has("$ref")) and (($s."$ref"|startswith("#/$defs/"))|not) then error("only bundled local $defs references are supported")
   else
    ([($s.properties // {} | .[]), ($s."$defs" // {} | .[]),
      (if $s|has("additionalProperties") then $s.additionalProperties else empty end),
      (if $s|has("propertyNames") then $s.propertyNames else empty end),
      (if $s|has("items") then $s.items else empty end),
      ($s.allOf // [] | .[]), ($s.anyOf // [] | .[]), ($s.oneOf // [] | .[]),
      (if $s|has("not") then $s.not else empty end)] | all(.[]; compile(.)))
   end;
 def matches($t;$v): if $t=="integer" then ($v|type)=="number" and ($v|floor)==$v else ($v|type)==$t end;
 def v($s;$x;$p;$defs):
   if $s==true then [] elif $s==false then [$p+": forbidden by schema"]
   elif ($s|has("$ref")) then
     ($s."$ref"|ltrimstr("#/$defs/")) as $name |
     if $defs|has($name) then v($defs[$name];$x;$p;$defs) + v($s|del(."$ref");$x;$p;$defs)
     else error("unresolved bundled schema reference: "+$name) end
   elif ($s|has("type")) and ((if ($s.type|type)=="array" then any($s.type[]; matches(.;$x)) else matches($s.type;$x) end)|not)
     then [$p+": unexpected type, expected "+($s.type|tojson)]
   else
     (if ($s|has("const")) and $x!=$s.const then [$p+": const mismatch"] else [] end) +
     (if ($s|has("enum")) and ($s.enum|index($x))==null then [$p+": unsupported value"] else [] end) +
     (if ($x|type)=="object" then
       [($s.required // [])[] as $k | select(($x|has($k))|not) | $p+"/"+$k+": required"] +
       (if ($s|has("minProperties")) and ($x|length)<$s.minProperties then [$p+": too few properties"] else [] end) +
       (if ($s|has("maxProperties")) and ($x|length)>$s.maxProperties then [$p+": too many properties"] else [] end) +
       [ $x|keys[] as $k |
         if ($s.properties // {}|has($k)) then v($s.properties[$k];$x[$k];$p+"/"+$k;$defs)[]
         elif ($s|has("additionalProperties")) then v($s.additionalProperties;$x[$k];$p+"/"+$k;$defs)[] else empty end ] +
       (if $s|has("propertyNames") then [$x|keys[] as $k | v($s.propertyNames;$k;$p+"/"+$k;$defs)[]] else [] end)
     elif ($x|type)=="array" then
       (if ($s|has("minItems")) and ($x|length)<$s.minItems then [$p+": too few items"] else [] end) +
       (if ($s|has("maxItems")) and ($x|length)>$s.maxItems then [$p+": too many items"] else [] end) +
       (if $s.uniqueItems==true and ($x|unique|length)!=($x|length) then [$p+": duplicate items"] else [] end) +
       (if $s|has("items") then [range(0;$x|length) as $i | v($s.items;$x[$i];$p+"/"+($i|tostring);$defs)[]] else [] end)
     elif ($x|type)=="string" then
       (if ($s|has("minLength")) and ($x|length)<$s.minLength then [$p+": string too short"] else [] end) +
       (if ($s|has("maxLength")) and ($x|length)>$s.maxLength then [$p+": string too long"] else [] end) +
       (if ($s|has("pattern")) and (($x|test($s.pattern))|not) then [$p+": invalid string pattern"] else [] end)
     elif ($x|type)=="number" then
       (if ($s|has("minimum")) and $x<$s.minimum then [$p+": below minimum"] else [] end) +
       (if ($s|has("maximum")) and $x>$s.maximum then [$p+": above maximum"] else [] end)
     else [] end) +
     [($s.allOf // [])[] as $sub | v($sub;$x;$p;$defs)[]] +
     (if ($s|has("anyOf")) and ([ $s.anyOf[] as $sub | select((v($sub;$x;$p;$defs)|length)==0)]|length)==0 then [$p+": no anyOf match"] else [] end) +
     (if ($s|has("oneOf")) and ([ $s.oneOf[] as $sub | select((v($sub;$x;$p;$defs)|length)==0)]|length)!=1 then [$p+": expected exactly one oneOf match"] else [] end) +
     (if ($s|has("not")) and (v($s.not;$x;$p;$defs)|length)==0 then [$p+": forbidden value"] else [] end)
   end;
 $schema[0] as $s |
 if $s."$schema"!="https://json-schema.org/draft/2020-12/schema" then error("unsupported schema dialect") else . end |
 compile($s) |
 v($s;$data[0];"";$s."$defs" // {}) |
 if length==0 then true else error(join("; ")) end
' >/dev/null; then
 printf '%s: contract validation failed (%s)\n' "$data" "${schema##*/}" >&2
 exit 1
fi
