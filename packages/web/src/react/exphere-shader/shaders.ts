export const vertexSource = `#version 300 es
void main() {
  vec2 position = vec2((gl_VertexID << 1) & 2, gl_VertexID & 2);
  gl_Position = vec4(position * 2.0 - 1.0, 0.0, 1.0);
}`;

// Layered, translucent petal surfaces; all detail is smooth geometry, not grain.
export const fragmentSource = `#version 300 es
precision highp float;
uniform vec2 resolution;
uniform float elapsed;
uniform vec3 primary;
uniform vec3 primaryHover;
uniform vec3 background;
uniform vec3 surface;
out vec4 outputColor;

float softBand(float distance, float width) {
  float scaled = distance / width;
  return exp(-scaled * scaled);
}

vec2 petalCoordinates(vec2 point, vec2 center, vec2 radius, float angle) {
  mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
  return rotation * (point - center) / radius;
}

vec3 curledPetal(vec3 underneath, vec2 point, vec2 center, vec2 radius,
                 float angle, float phase, vec3 lightColor, vec3 ink, float opacity) {
  vec2 local = petalCoordinates(point, center, radius, angle);
  local.x += 0.24 * local.y * local.y + 0.08 * sin(local.y * 2.8 + phase);
  local.y += 0.12 * sin(local.x * 2.2 - phase);
  float edge = length(local * vec2(1.0, 1.0 + 0.09 * local.x));
  float coverage = 1.0 - smoothstep(0.90, 1.13, edge);

  // The face bends through the light; its shading varies inside the silhouette.
  float curl = local.y + 0.25 * local.x * local.x;
  vec3 normal = normalize(vec3(
    0.65 * local.x + 0.22 * sin(local.y * 3.0 + phase),
    0.90 * curl,
    0.72 + 0.30 * cos(local.x * 2.1)
  ));
  float lighting = max(0.0, dot(normal, normalize(vec3(-0.70, -0.45, 1.0))));
  float turnedFace = softBand(curl - 0.35, 0.46);
  float pigment = 0.15 + 0.40 * (1.0 - lighting) + 0.20 * turnedFace;
  vec3 face = mix(lightColor, ink, pigment);

  // A curled sheet has two faces meeting along a bent lip. Broad opposing
  // light and shadow bands give that turn depth independently of its outline.
  float fold = local.y + 0.38 * local.x + 0.32 * local.x * local.x;
  fold += 0.08 * sin(local.x * 3.0 + phase);
  float rolledFace = softBand(fold - 0.12, 0.27);
  float litFace = softBand(fold + 0.28, 0.24);
  face = mix(face, mix(lightColor, ink, 0.65), rolledFace * 0.62);
  face = mix(face, lightColor, litFace * 0.68);

  // Transmitted light belongs to the upper/left lip, not an outline of the oval.
  float backlitEdge = softBand(edge - 0.91, 0.21);
  backlitEdge *= 1.0 - smoothstep(-0.30, 0.65, local.x + local.y);
  face = mix(face, lightColor, backlitEdge * 0.64);
  float innerCrease = softBand(curl - 0.62, 0.19);
  face = mix(face, mix(lightColor, ink, 0.56), innerCrease * 0.20);

  float contact = softBand(edge - 1.09, 0.30);
  contact *= smoothstep(-0.45, 0.65, local.y);
  underneath = mix(underneath, mix(lightColor, ink, 0.49), contact * opacity * 0.28);
  return mix(underneath, face, coverage * opacity);
}

void main() {
  vec2 point = gl_FragCoord.xy / resolution;
  point.y = 1.0 - point.y;
  float aspect = resolution.x / resolution.y;
  point.x = (point.x - 0.5) * clamp(aspect / 2.23, 0.90, 1.3) + 0.5;
  float phase = elapsed * 1.04719755;
  float opening = 0.5 + 0.5 * cos(phase);
  point += vec2(
    0.025 * sin(point.y * 4.5 + phase),
    0.018 * sin(point.x * 4.0 - phase)
  );

  vec3 pale = mix(background, surface, 0.24);
  float leftBend = point.x + 0.08 * sin(point.y * 3.8 - phase);
  float leftShade = 1.0 - smoothstep(-0.15, 0.57, leftBend);
  vec3 color = mix(pale, primary, 0.10 + leftShade * 0.33);

  // Far petals remain soft behind the foreground, with independent bending phases.
  color = curledPetal(color, point, vec2(0.88, 0.95), vec2(0.43, 0.52),
                     -0.38, phase + 1.4, pale, primaryHover, 0.96);
  color = curledPetal(color, point, vec2(0.97, -0.24), vec2(0.50, 0.37),
                     0.18, phase + 2.2, pale, primary, 0.58);

  // A broad diagonal sheet enters from the lower-left. Its bow catches light
  // across a surface, while a separate soft trough supplies overlap and depth.
  float sheetDistance = point.x + point.y * 0.58 - 0.71;
  sheetDistance += 0.075 * sin(point.y * 3.7 - phase);
  float sheetCoverage = 1.0 - smoothstep(-0.035, 0.11, sheetDistance);
  float sheetBend = softBand(sheetDistance + 0.21, 0.13);
  float sheetLight = softBand(sheetDistance + 0.055, 0.11);
  vec3 sheetColor = mix(pale, primary, 0.12 + sheetBend * 0.37);
  sheetColor = mix(sheetColor, pale, sheetLight * (0.46 + opening * 0.30));
  float trailingFold = softBand(sheetDistance + 0.40, 0.10);
  sheetColor = mix(sheetColor, mix(pale, primaryHover, 0.40), trailingFold * 0.24);
  color = mix(color, sheetColor, sheetCoverage * smoothstep(0.02, 0.40, point.y));

  // The luminous opening changes width as the sheets turn, rather than sliding
  // a rigid white stripe over the completed composition.
  float transmittedLight = softBand(sheetDistance - 0.075, 0.13 + opening * 0.05);
  color = mix(color, background, transmittedLight * (0.38 + opening * 0.40));

  vec2 frontCenter = vec2(0.94 + 0.025 * sin(phase), 0.13 + 0.025 * cos(phase));
  vec2 frontRadius = vec2(0.28 + 0.020 * cos(phase), 0.51 + 0.020 * sin(phase));
  color = curledPetal(color, point, frontCenter, frontRadius,
                     0.50 + 0.07 * sin(phase), phase, pale, primaryHover, 0.96);

  // Diffuse light at the crown and base joins the separate layers without grain.
  vec2 crown = (point - vec2(0.52, -0.05)) / vec2(0.27, 0.50);
  color = mix(color, background, exp(-dot(crown, crown)) * 0.48);
  vec2 lowerLight = (point - vec2(0.68, 0.86)) / vec2(0.22, 0.34);
  color = mix(color, pale, exp(-dot(lowerLight, lowerLight)) * (0.10 + opening * 0.08));
  outputColor = vec4(color, 1.0);
}`;
