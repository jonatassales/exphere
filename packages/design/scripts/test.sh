#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
node --input-type=module <<'NODE'
import assert from 'node:assert/strict';
import { cpSync, mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createRequire } from 'node:module';
import { spawn, spawnSync } from 'node:child_process';
let watcher;
const root = mkdtempSync(join(tmpdir(), 'design-contract-'));
try {
  const pkg = join(root, 'design');
  cpSync(process.cwd(), pkg, { recursive: true, filter: (path) => !/\/(node_modules|dist)(\/|$)/.test(path) });
  const build = () => spawnSync('sh', ['scripts/build.sh'], { cwd: pkg, encoding: 'utf8' });
  const result = build();
  assert.equal(result.status, 0, result.stderr);
  mkdirSync(join(root, 'node_modules/@repo'), { recursive: true });
  symlinkSync(pkg, join(root, 'node_modules/@repo/design'));
  const consumer = createRequire(join(root, 'consumer.cjs'));
  const css = readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8');
  const jsonText = readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8');
  const json = JSON.parse(jsonText);
  assert.match(css, /--design-dimensions-space-4: 1rem;/);
  const lightCss = css.match(/\[data-theme="light"\] \{([^}]+)\}/)?.[1];
  assert.ok(lightCss, 'the public CSS export must include the light theme');
  const palette = [
    ['primary', 'primary', '#6D0AD6'],
    ['primaryHover', 'primary-hover', '#5408A5'],
    ['background', 'background', '#FFFFFF'],
    ['surface', 'surface', '#F9F9F9'],
    ['text', 'text', '#27262A'],
    ['textSecondary', 'text-secondary', '#535257'],
    ['border', 'border', '#DDDDDD'],
  ];
  for (const [role, cssName, value] of palette) {
    assert.equal(json.themes.light.color[role]?.$value, value, `${role} must expose the supplied palette value`);
    assert.ok(lightCss.includes(`--design-color-${cssName}: ${value};`), `${role} must reach the light CSS export`);
  }
  assert.equal(json.themes.light.color.$type, 'color');
  assert.equal(json.themes.light.color.foreground.$value, '{themes.light.color.text}');
  assert.match(lightCss, /--design-color-foreground: var\(--design-color-text\);/);
  const darkCss = css.match(/\[data-theme="dark"\] \{([^}]+)\}/)?.[1];
  assert.ok(darkCss, 'the public CSS export must retain the dark theme');
  for (const [role, shade] of [['background', '950'], ['foreground', '50'], ['surface', '900'], ['border', '800']]) {
    assert.equal(json.themes.dark.color[role].$value, `{color.gray.${shade}}`);
    assert.ok(darkCss.includes(`--design-color-${role}: var(--design-color-gray-${shade});`));
  }
  assert.equal(json.color.$type, 'color');
  assert.equal(build().status, 0);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), css);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'), jsonText);
  console.log('PASS: public exports expose the basic light palette, foreground alias, unchanged dark roles, and deterministic values');
  const colorFile = join(pkg, 'tokens/color.json');
  const originalColor = readFileSync(colorFile, 'utf8');
  const cyclic = JSON.parse(originalColor);
  cyclic.color.gray['50'].$value = '{color.gray.100}';
  cyclic.color.gray['100'].$value = '{color.gray.50}';
  writeFileSync(colorFile, JSON.stringify(cyclic));
  const invalid = build();
  assert.notEqual(invalid.status, 0, 'a cycle must fail generation');
  assert.match(invalid.stderr, /cycle.*color\.gray/i);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), css);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'), jsonText);
  writeFileSync(colorFile, originalColor);
  console.log('PASS: invalid aliases fail without replacing existing outputs');
  const invalidCases = [
    ['CSS injection', (value) => { value.color.gray['50'].$value = '#fff; } body { color: red'; }],
    ['missing type', (value) => { delete value.color.$type; }],
    ['unknown type', (value) => { value.color.$type = 'anything'; }],
    ['missing alias', (value) => { value.color.gray['50'].$value = '{missing.token}'; }],
    ['type mismatch', (value) => { value.color.gray['50'].$value = '{dimensions.space.4}'; }],
    ['normalization collision', (value) => { value.color.gray_50 = { $value: '#ffffff' }; }],
    ['negative dimension', (value) => { value.extra = { $type: 'dimension', x: { $value: '-1px' } }; }],
    ['CSS self-reference collision', (value) => { value.themes.light.color.gray = { '50': { $value: '{color.gray.50}' } }; }],
    ['invalid theme', (value) => { value.themes.other = value.themes.light; }],
  ];
  for (const [name, mutate] of invalidCases) {
    const value = JSON.parse(originalColor);
    mutate(value);
    writeFileSync(colorFile, JSON.stringify(value));
    assert.notEqual(build().status, 0, `${name} must fail generation`);
    assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), css);
    assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'), jsonText);
  }
  writeFileSync(colorFile, '{"color":{"$type":"color","same":{"$value":"#fff","$value":"#000"}}}');
  assert.notEqual(build().status, 0, 'duplicate JSON keys must fail generation');
  writeFileSync(colorFile, originalColor);
  console.log('PASS: invalid schemas and unsafe values preserve the last valid artifacts');
  const waitFor = async (predicate, message) => {
    for (let attempt = 0; attempt < 250; attempt++) {
      if (predicate()) return;
      if (watcher.exitCode !== null) throw new Error(`${message}: watcher exited`);
      await new Promise((resolve) => setTimeout(resolve, 20));
    }
    throw new Error(message);
  };
  let log = '';
  watcher = spawn('sh', ['scripts/dev.sh'], { cwd: pkg, stdio: ['ignore', 'pipe', 'pipe'] });
  watcher.stdout.on('data', (data) => { log += data; });
  watcher.stderr.on('data', (data) => { log += data; });
  await waitFor(() => log.includes('watching'), 'watch must remain active');
  const changed = JSON.parse(originalColor);
  changed.themes.light.color.primary.$value = '#7A20E0';
  writeFileSync(colorFile, JSON.stringify(changed));
  await waitFor(() => {
    try {
      const watchedCss = readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8');
      const watchedJson = JSON.parse(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'));
      return watchedCss.includes('--design-color-primary: #7A20E0;') && watchedJson.themes.light.color.primary.$value === '#7A20E0';
    }
    catch { return false; }
  }, 'watch must regenerate consumer outputs after an edit');
  const validWatchedCss = readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8');
  const validWatchedJson = readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8');
  changed.themes.light.color.primary.$value = '{absent.target}';
  writeFileSync(colorFile, JSON.stringify(changed));
  await waitFor(() => log.includes('missing alias target'), 'watch must report invalid input');
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), validWatchedCss);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'), validWatchedJson);
  const stopped = new Promise((resolve) => watcher.once('exit', (code, signal) => resolve({ code, signal })));
  watcher.kill('SIGTERM');
  const deadline = setTimeout(() => watcher.kill('SIGKILL'), 3000);
  try { assert.deepEqual(await stopped, { code: 0, signal: null }); }
  finally { clearTimeout(deadline); }
  console.log('PASS: watch publishes valid edits, preserves outputs on failure, and stops cleanly');
} finally {
  if (watcher && watcher.exitCode === null && watcher.signalCode === null) {
    const exited = new Promise((resolve) => watcher.once('exit', resolve));
    watcher.kill('SIGKILL');
    await exited;
  }
  rmSync(root, { recursive: true, force: true });
}
NODE
