export const vertexSource = `#version 300 es
void main() {
  vec2 position = vec2((gl_VertexID << 1) & 2, gl_VertexID & 2);
  gl_Position = vec4(position * 2.0 - 1.0, 0.0, 1.0);
}`;

// Broad petal silhouettes and flowing gaps, without texture or per-pixel grain.
export const fragmentSource = `#version 300 es
precision highp float;
uniform vec2 resolution;
uniform float elapsed;
uniform vec3 primary;
uniform vec3 primaryHover;
uniform vec3 background;
uniform vec3 surface;
out vec4 outputColor;

float petal(vec2 point, vec2 center, vec2 radius, float angle) {
  vec2 offset = point - center;
  mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
  vec2 local = rotation * offset / radius;
  return dot(local, local);
}

vec3 curledPetal(vec3 underneath, vec2 point, vec2 center, vec2 radius,
                 float angle, float phase, vec3 lightColor, vec3 ink) {
  mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
  vec2 local = rotation * (point - center) / radius;
  local.x += 0.20 * local.y * local.y - 0.12 * sin(local.y * 2.6 + phase);
  float distance = length(local);
  float coverage = 1.0 - smoothstep(0.88, 1.12, distance);

  // A bowed face rolls away from the light, then turns back along its thin rim.
  float bowl = sqrt(max(0.02, 1.0 - min(distance * distance, 0.98)));
  vec3 normal = normalize(vec3(local.x * 0.7, local.y * 0.9, bowl));
  float lighting = clamp(dot(normal, normalize(vec3(-0.55, -0.65, 1.0))), 0.0, 1.0);
  float rolledEdge = exp(-pow((distance - 0.88) / 0.15, 2.0));
  float underside = smoothstep(-0.2, 0.85, local.y) * (1.0 - lighting);
  float pigment = 0.37 + 0.22 * (1.0 - lighting) + 0.14 * underside;
  vec3 face = mix(lightColor, ink, pigment);
  face = mix(face, lightColor, rolledEdge * (0.32 + 0.36 * lighting));

  // A soft contact shadow separates this sheet from the one beneath it.
  float shadow = exp(-pow((distance - 1.06) / 0.23, 2.0));
  underneath = mix(underneath, mix(lightColor, ink, 0.30), shadow * 0.22);
  return mix(underneath, face, coverage);
}

void main() {
  vec2 point = gl_FragCoord.xy / resolution;
  point.y = 1.0 - point.y;
  float aspect = resolution.x / resolution.y;
  point.x = (point.x - 0.5) * clamp(aspect / 2.23, 0.60, 1.3) + 0.5;
  float phase = elapsed * 0.88;
  vec2 drift = vec2(sin(phase) * 0.07, cos(phase * 0.8) * 0.06);
  point += vec2(
    0.055 * sin(point.y * 5.2 + phase * 0.9),
    0.04 * sin(point.x * 4.0 - phase * 0.7)
  );

  vec3 pale = mix(background, surface, 0.24);
  vec3 lavender = mix(pale, primary, 0.38);
  float leftShade = 1.0 - smoothstep(-0.28, 0.56, point.x);
  vec3 color = mix(pale, lavender, leftShade * 0.90 + 0.14);

  // A second translucent sheet curls up from the lower-right edge.
  float lowerPetal = petal(point, vec2(1.01, 1.25) - drift * 0.8, vec2(0.68, 0.48), 0.36);
  color = mix(color, lavender, (1.0 - smoothstep(0.25, 1.75, lowerPetal)) * 0.92);

  // A diagonal sheet rises from the lower-left, with its own shaded face and lip.
  float sheetCoordinate = point.x + point.y * 0.47;
  float sheetEdge = 0.72 + 0.055 * sin(point.y * 4.2 - phase);
  float sheetDistance = sheetCoordinate - sheetEdge;
  float sheetCoverage = 1.0 - smoothstep(-0.04, 0.09, sheetDistance);
  float sheetBend = exp(-pow((sheetDistance + 0.13) / 0.16, 2.0));
  vec3 sheetColor = mix(pale, primary, 0.18 + 0.24 * sheetBend);
  float sheetLip = exp(-pow((sheetDistance + 0.015) / 0.037, 2.0));
  sheetColor = mix(sheetColor, background, sheetLip * 0.65);
  color = mix(color, sheetColor, sheetCoverage * smoothstep(0.0, 0.75, point.y));

  // The top-right petal rolls across that sheet. Independent curvature gives depth.
  color = curledPetal(color, point, vec2(0.94, 0.25) + drift,
                     vec2(0.43, 0.30), -0.45, phase * 0.65, pale, primaryHover);

  // Wide diagonal light flowing between the folds; no repeated curtain stripes.
  float diagonal = point.x - 0.65 + point.y * 0.44;
  diagonal += sin(point.y * 5.0 - phase) * 0.075;
  float light = exp(-pow(diagonal / (0.15 + 0.025 * sin(phase)), 2.0));
  float veil = exp(-pow((diagonal + 0.22) / 0.18, 2.0));
  color = mix(color, pale, light * 0.46);
  color = mix(color, mix(pale, primary, 0.12), veil * 0.38);
  float sheen = exp(-pow((diagonal + 0.18 + 0.025 * sin(point.y * 11.0 - phase)) / 0.045, 2.0));
  color = mix(color, pale, sheen * smoothstep(0.25, 0.9, point.y) * 0.22);

  float topLight = exp(-petal(point, vec2(0.57, -0.12) + drift * 0.4, vec2(0.30, 0.50), -0.25));
  color = mix(color, background, topLight * 0.62);
  outputColor = vec4(color, 1.0);
}`;
