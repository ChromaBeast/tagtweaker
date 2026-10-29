// Security rules tests for storage.rules, run against the local emulator.
import { after, before, test } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { ref, uploadBytes } from 'firebase/storage';

let env;
const png = new Uint8Array([0x89, 0x50, 0x4e, 0x47]);

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-tagtweaker',
    storage: { rules: readFileSync('../storage.rules', 'utf8') },
  });
});

after(async () => {
  await env?.cleanup();
});

const storage = (uid) => env.authenticatedContext(uid).storage();

test('owner can upload a small image to their profile folder', async () => {
  await assertSucceeds(
    uploadBytes(ref(storage('alice'), 'user_profiles/alice/avatar.png'), png, {
      contentType: 'image/png',
    }),
  );
});

test("cannot upload into another user's folder", async () => {
  await assertFails(
    uploadBytes(ref(storage('bob'), 'user_profiles/alice/avatar.png'), png, {
      contentType: 'image/png',
    }),
  );
});

test('non-image uploads are rejected', async () => {
  await assertFails(
    uploadBytes(ref(storage('alice'), 'user_profiles/alice/notes.txt'), png, {
      contentType: 'text/plain',
    }),
  );
});

test('files over 2 MB are rejected', async () => {
  const big = new Uint8Array(2 * 1024 * 1024 + 1);
  await assertFails(
    uploadBytes(ref(storage('alice'), 'user_profiles/alice/big.png'), big, {
      contentType: 'image/png',
    }),
  );
});

test('paths outside user_profiles are closed', async () => {
  await assertFails(
    uploadBytes(ref(storage('alice'), 'public/anything.png'), png, {
      contentType: 'image/png',
    }),
  );
});
