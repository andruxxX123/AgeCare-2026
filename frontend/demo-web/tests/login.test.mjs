import assert from 'node:assert/strict';
import { createRequire } from 'node:module';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const require = createRequire(import.meta.url);
const { accounts, authenticate } = require('../agecare-auth.js');
const html = await readFile(new URL('../index.html', import.meta.url), 'utf8');
const app = await readFile(new URL('../app.js', import.meta.url), 'utf8');

test('cada cuenta pública accede exclusivamente a su perfil', () => {
  const expected = ['Familia', 'Cuidador', 'Médico', 'Adulto mayor'];
  assert.deepEqual([...new Set(Object.values(accounts).map(({ role }) => role))], expected);
  for (const [email, account] of Object.entries(accounts)) {
    assert.equal(authenticate(email, account.password), account.role);
    assert.equal(authenticate(` ${email.toUpperCase()} `, account.password), account.role);
    assert.equal(authenticate(email, 'incorrecta'), null);
  }
  assert.equal(authenticate('nadie@agecare.app', 'Familia123!'), null);
  assert.equal(authenticate(null, 'Familia123!'), null);
});

test('la interfaz exige login y cierre de sesión para cambiar de perfil', () => {
  assert.match(html, /id="login-form"/);
  assert.match(html, /id="login-error"[^>]*role="alert"/);
  assert.match(html, /id="logout"/);
  assert.doesNotMatch(html, /<select id="role"/);
  assert.match(app, /if \(!currentRole\) return;/);
  assert.match(app, /localStorage\.removeItem\(SESSION_KEY\)/);
  assert.match(app, /state\.role = currentRole/);
  assert.doesNotMatch(app, /if \(currentRole\) enterAgeCare\(currentRole\)/);
  assert.match(app, /^showLogin\(\);/m);
});



