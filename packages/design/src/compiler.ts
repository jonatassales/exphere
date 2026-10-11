import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  renameSync,
  rmSync,
  unwatchFile,
  watchFile,
  writeFileSync,
} from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

type Group = { [key: string]: Group | string };
type Token = {
  id: string;
  name: string;
  type: string;
  value: string;
  mode: string;
};
const root = dirname(dirname(fileURLToPath(import.meta.url)));
const input = join(root, "tokens");
const output = join(root, "dist");
const sourceNames = ["color", "typography", "dimensions", "effects"];
const supportedTypes = new Set([
  "color",
  "dimension",
  "fontFamily",
  "shadow",
  "cubicBezier",
]);
const aliasPattern = /^\{([A-Za-z0-9_-]+(?:\.[A-Za-z0-9_-]+)*)\}$/;
const dimensionPattern = /^(?:\d+(?:\.\d+)?|\.\d+)(?:px|rem|em)$/;
const hexColorPattern =
  /^#(?:[\da-fA-F]{3}|[\da-fA-F]{4}|[\da-fA-F]{6}|[\da-fA-F]{8})$/;
const variable = (id: string) =>
  `--design-${id
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/[._]/g, "-")
    .toLowerCase()}`;

function readSource(name: string): unknown {
  const text = readFileSync(join(input, `${name}.json`), "utf8");
  const value: unknown = JSON.parse(text);
  // JSON.parse accepts duplicate keys. Reject them before accepting the parsed graph.
  const objects: Set<string>[] = [];
  const lexemes = /"(?:\\.|[^"\\])*"|[{}]/g;
  for (const match of text.matchAll(lexemes)) {
    const lexeme = match[0];
    if (lexeme === "{") objects.push(new Set());
    else if (lexeme === "}") objects.pop();
    else if (/^\s*:/.test(text.slice((match.index ?? 0) + lexeme.length))) {
      const key: string = JSON.parse(lexeme);
      const keys = objects.at(-1);
      if (keys?.has(key)) throw new Error(`duplicate key ${key} in ${name}`);
      keys?.add(key);
    }
  }
  return value;
}

function isGroup(value: unknown): value is Group {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function validLiteral(type: string, value: string): boolean {
  if (type === "color")
    return (
      hexColorPattern.test(value) ||
      value === "transparent" ||
      value === "currentColor"
    );
  if (type === "dimension")
    return (
      dimensionPattern.test(value) && Number.isFinite(Number.parseFloat(value))
    );
  if (type === "fontFamily")
    return /^[A-Za-z][A-Za-z0-9 -]*(?:,\s*[A-Za-z][A-Za-z0-9 -]*)*$/.test(
      value,
    );
  if (type === "shadow") {
    if (value === "none") return true;
    const parts = value.split(/\s+/);
    const color = parts.pop() ?? "";
    return (
      hexColorPattern.test(color) &&
      parts.length >= 2 &&
      parts.length <= 4 &&
      parts.every((part, index) => {
        const unsigned = part.startsWith("-") ? part.slice(1) : part;
        return (
          validLiteral("dimension", unsigned) &&
          (index !== 2 || !part.startsWith("-"))
        );
      })
    );
  }
  if (type === "cubicBezier") {
    const match =
      /^cubic-bezier\(\s*(-?(?:\d+(?:\.\d+)?|\.\d+))\s*,\s*(-?(?:\d+(?:\.\d+)?|\.\d+))\s*,\s*(-?(?:\d+(?:\.\d+)?|\.\d+))\s*,\s*(-?(?:\d+(?:\.\d+)?|\.\d+))\s*\)$/.exec(
        value,
      );
    if (!match) return false;
    const values = match.slice(1).map(Number);
    return (
      values.every(Number.isFinite) &&
      values[0] >= 0 &&
      values[0] <= 1 &&
      values[2] >= 0 &&
      values[2] <= 1
    );
  }
  return false;
}

function canonical(group: Group): Group {
  return Object.fromEntries(
    Object.keys(group)
      .sort()
      .map((key) => [
        key,
        typeof group[key] === "string" ? group[key] : canonical(group[key]),
      ]),
  );
}

function build(): void {
  const document: Group = Object.create(null);
  for (const category of sourceNames) {
    const source = readSource(category);
    if (!isGroup(source))
      throw new Error(`${category} must contain a token object`);
    for (const [key, value] of Object.entries(source)) {
      if (Object.hasOwn(document, key))
        throw new Error(`duplicate token group ${key}`);
      document[key] = value;
    }
  }
  const tokens: Token[] = [];
  const names = new Set<string>();
  function visit(group: unknown, path: string[], inherited = ""): void {
    const id = path.join(".") || "<root>";
    if (!isGroup(group)) throw new Error(`expected token object at ${id}`);
    if (
      "$type" in group &&
      (typeof group.$type !== "string" || !supportedTypes.has(group.$type))
    ) {
      throw new Error(`unsupported type at ${id}`);
    }
    const type = typeof group.$type === "string" ? group.$type : inherited;
    const children = Object.keys(group).filter((key) => !key.startsWith("$"));
    for (const key of Object.keys(group)) {
      if (
        key.startsWith("$") &&
        !["$type", "$value", "$description"].includes(key)
      )
        throw new Error(`unsupported metadata ${key} at ${id}`);
      if (key === "$description" && typeof group[key] !== "string")
        throw new Error(`invalid description at ${id}`);
    }
    if ("$value" in group) {
      if (
        !path.length ||
        children.length ||
        !type ||
        typeof group.$value !== "string"
      )
        throw new Error(`invalid token or missing type at ${id}`);
      const mode = path[0] === "themes" ? path[1] : "";
      if (
        path[0] === "themes" &&
        (path.length < 3 || !["light", "dark"].includes(mode))
      )
        throw new Error(`invalid theme at ${id}`);
      const name = variable((mode ? path.slice(2) : path).join("."));
      const identity = `${mode}:${name}`;
      if (names.has(identity))
        throw new Error(`CSS normalization collision at ${id}`);
      names.add(identity);
      if (!aliasPattern.test(group.$value) && !validLiteral(type, group.$value))
        throw new Error(`invalid ${type} value at ${id}`);
      tokens.push({ id, name, type, value: group.$value, mode });
      return;
    }
    for (const key of children.sort()) {
      if (!/^[A-Za-z0-9][A-Za-z0-9_-]*$/.test(key))
        throw new Error(`invalid token key ${key} at ${id}`);
      if (
        path.length === 1 &&
        path[0] === "themes" &&
        !["light", "dark"].includes(key)
      )
        throw new Error(`invalid theme ${key}`);
      visit(group[key], [...path, key], type);
    }
  }
  visit(document, []);
  if (!tokens.length) throw new Error("no tokens found");
  const foundationNames = new Set(
    tokens.filter((token) => !token.mode).map((token) => token.name),
  );
  for (const token of tokens) {
    if (token.mode && foundationNames.has(token.name))
      throw new Error(`theme/foundation CSS collision at ${token.id}`);
  }
  const byId = new Map(tokens.map((token) => [token.id, token]));
  const visited = new Set<string>();
  const active = new Set<string>();
  function validateAlias(token: Token): void {
    if (active.has(token.id)) throw new Error(`alias cycle at ${token.id}`);
    if (visited.has(token.id)) return;
    active.add(token.id);
    const alias = aliasPattern.exec(token.value);
    if (alias) {
      const target = byId.get(alias[1]);
      if (!target)
        throw new Error(`missing alias target ${alias[1]} at ${token.id}`);
      if (target.type !== token.type)
        throw new Error(`alias type mismatch at ${token.id}`);
      if (target.mode && target.mode !== token.mode)
        throw new Error(`cross-theme alias at ${token.id}`);
      validateAlias(target);
    }
    active.delete(token.id);
    visited.add(token.id);
  }
  for (const token of tokens) validateAlias(token);
  const sections = ["", "light", "dark"].map((mode) => {
    const selector = mode ? `[data-theme="${mode}"]` : ":root";
    const lines = tokens
      .filter((token) => token.mode === mode)
      .sort((a, b) => (a.name < b.name ? -1 : 1))
      .map((token) => {
        const alias = aliasPattern.exec(token.value);
        const value = alias ? `var(${byId.get(alias[1])?.name})` : token.value;
        return `  ${token.name}: ${value};`;
      });
    return `${selector} {\n${lines.join("\n")}\n}`;
  });
  const stage = mkdtempSync(join(root, ".design-build-"));
  const next = join(stage, "next");
  const previous = join(stage, "previous");
  try {
    mkdirSync(next);
    writeFileSync(join(next, "tokens.css"), `${sections.join("\n\n")}\n`);
    writeFileSync(
      join(next, "tokens.json"),
      `${JSON.stringify(canonical(document), null, 2)}\n`,
    );
    if (existsSync(output)) renameSync(output, previous);
    try {
      renameSync(next, output);
    } catch (error) {
      if (existsSync(previous)) renameSync(previous, output);
      throw error;
    }
  } finally {
    rmSync(stage, { recursive: true, force: true });
  }
  console.log("design: generated tokens.css and tokens.json");
}

function attemptBuild(): boolean {
  try {
    build();
    return true;
  } catch (error) {
    console.error(
      `design: ${error instanceof Error ? error.message : String(error)}; existing outputs are stale`,
    );
    return false;
  }
}

if (process.argv.slice(2).some((argument) => argument !== "--watch")) {
  console.error("design: only --watch is supported");
  process.exitCode = 1;
} else if (process.argv.includes("--watch")) {
  let timer: ReturnType<typeof setTimeout> | undefined;
  const files = sourceNames.map((name) => join(input, `${name}.json`));
  const changed = () => {
    clearTimeout(timer);
    timer = setTimeout(attemptBuild, 50);
  };
  for (const file of files) watchFile(file, { interval: 200 }, changed);
  function stop(): void {
    clearTimeout(timer);
    for (const file of files) unwatchFile(file, changed);
  }
  process.on("SIGINT", stop);
  process.on("SIGTERM", stop);
  attemptBuild();
  console.log("design: watching token sources");
} else if (!attemptBuild()) {
  process.exitCode = 1;
}
