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
  assert.match(css, /\[data-theme="light"\]/);
  assert.match(css, /--design-color-background: var\(--design-color-gray-50\);/);
  assert.equal(json.themes.light.color.background.$value, '{color.gray.50}');
  assert.equal(json.color.$type, 'color');
  assert.equal(build().status, 0);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), css);
  assert.equal(readFileSync(consumer.resolve('@repo/design/tokens.json'), 'utf8'), jsonText);
  console.log('PASS: package exports preserve token references and deterministic values');
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
  changed.color.gray['50'].$value = '#eeeeee';
  writeFileSync(colorFile, JSON.stringify(changed));
  await waitFor(() => {
    try { return readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8').includes('--design-color-gray-50: #eeeeee;'); }
    catch { return false; }
  }, 'watch must regenerate consumer outputs after an edit');
  changed.color.gray['50'].$value = '{absent.target}';
  writeFileSync(colorFile, JSON.stringify(changed));
  await waitFor(() => log.includes('missing alias target'), 'watch must report invalid input');
  assert.match(readFileSync(consumer.resolve('@repo/design/tokens.css'), 'utf8'), /--design-color-gray-50: #eeeeee;/);
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
