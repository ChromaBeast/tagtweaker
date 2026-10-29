// Security rules tests for firestore.rules, run against the local emulator:
//   npm test   (wraps `firebase emulators:exec`)
import { after, before, beforeEach, describe, test } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  Timestamp,
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

let env;

const alice = () => env.authenticatedContext('alice').firestore();
const bob = () => env.authenticatedContext('bob').firestore();
const guest = () => env.unauthenticatedContext().firestore();

const product = { id: 'p1', title: 'Pixel 9', price: 79999, category: 'Smartphone' };

const quotation = (overrides = {}) => ({
  clientName: 'Acme Retail',
  createdAt: Timestamp.now(),
  lines: [{ productId: 'p1', title: 'Pixel 9', unitPrice: 75000, quantity: 1 }],
  rules: { markupPercent: 0, categoryMarkupPercent: {}, taxPercent: 18, rounding: 'none' },
  subtotal: 75000,
  taxPercent: 18,
  tax: 13500,
  total: 88500,
  itemCount: 1,
  ...overrides,
});

const pricingRules = (overrides = {}) => ({
  markupPercent: 15,
  categoryMarkupPercent: { Laptop: 5 },
  taxPercent: 18,
  rounding: 'endingIn9',
  ...overrides,
});

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-tagtweaker',
    firestore: { rules: readFileSync('../firestore.rules', 'utf8') },
  });
});

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'products/p1'), product);
  });
});

after(async () => {
  await env?.cleanup();
});

describe('products', () => {
  test('signed-in users can read the catalog', async () => {
    await assertSucceeds(getDoc(doc(alice(), 'products/p1')));
    await assertSucceeds(getDocs(collection(alice(), 'products')));
  });

  test('unauthenticated users cannot read the catalog', async () => {
    await assertFails(getDoc(doc(guest(), 'products/p1')));
  });

  test('nobody can write the catalog from the client', async () => {
    await assertFails(setDoc(doc(alice(), 'products/p2'), product));
    await assertFails(updateDoc(doc(alice(), 'products/p1'), { price: 1 }));
    await assertFails(deleteDoc(doc(alice(), 'products/p1')));
  });
});

describe('user profiles', () => {
  test('owner can write allowed fields only', async () => {
    const ref = doc(alice(), 'users/alice');
    await assertSucceeds(setDoc(ref, { displayName: 'Alice' }));
    await assertFails(setDoc(ref, { displayName: 'Alice', role: 'admin' }));
    await assertFails(setDoc(ref, { displayName: 'x'.repeat(101) }));
  });

  test('other users cannot read or write a profile', async () => {
    await assertFails(getDoc(doc(bob(), 'users/alice')));
    await assertFails(setDoc(doc(bob(), 'users/alice'), { displayName: 'Mallory' }));
  });
});

describe('favourites', () => {
  test('owner can add a favourite whose id matches the doc id', async () => {
    await assertSucceeds(setDoc(doc(alice(), 'users/alice/favourites/p1'), product));
  });

  test('favourite id must match the document id', async () => {
    await assertFails(
      setDoc(doc(alice(), 'users/alice/favourites/p2'), product),
    );
  });

  test('oversized favourite documents are rejected', async () => {
    const big = { ...product };
    for (let i = 0; i < 25; i++) big[`f${i}`] = i;
    await assertFails(setDoc(doc(alice(), 'users/alice/favourites/p1'), big));
  });

  test("users cannot touch someone else's favourites", async () => {
    await assertFails(getDocs(collection(bob(), 'users/alice/favourites')));
    await assertFails(setDoc(doc(bob(), 'users/alice/favourites/p1'), product));
  });
});

describe('quotations', () => {
  const quotes = (db, uid = 'alice') => collection(db, `users/${uid}/quotations`);

  test('owner can create, read and delete a valid quotation', async () => {
    const ref = await assertSucceeds(addDoc(quotes(alice()), quotation()));
    await assertSucceeds(getDocs(quotes(alice())));
    await assertSucceeds(deleteDoc(doc(alice(), ref.path)));
  });

  test('quotations are immutable once saved', async () => {
    const ref = await addDoc(quotes(alice()), quotation());
    await assertFails(updateDoc(doc(alice(), ref.path), { total: 1 }));
  });

  test('other users cannot read or create quotations', async () => {
    await assertFails(getDocs(quotes(bob())));
    await assertFails(addDoc(quotes(bob()), quotation()));
  });

  test('rejects unknown or missing fields', async () => {
    await assertFails(addDoc(quotes(alice()), quotation({ approvedBy: 'me' })));
    const { total, ...withoutTotal } = quotation();
    await assertFails(addDoc(quotes(alice()), withoutTotal));
  });

  test('rejects invalid values', async () => {
    const invalid = [
      { clientName: 'x'.repeat(101) },
      { createdAt: 'yesterday' },
      { lines: [] },
      { lines: Array.from({ length: 201 }, () => ({})) },
      { total: -1 },
      { itemCount: 0 },
      { itemCount: 1.5 },
    ];
    for (const overrides of invalid) {
      await assertFails(addDoc(quotes(alice()), quotation(overrides)));
    }
  });
});

describe('pricing settings', () => {
  const rulesDoc = (db, uid = 'alice') => doc(db, `users/${uid}/settings/pricing`);

  test('owner can save and read pricing rules', async () => {
    await assertSucceeds(setDoc(rulesDoc(alice()), pricingRules()));
    await assertSucceeds(getDoc(rulesDoc(alice())));
  });

  test('only the pricing settings document is writable', async () => {
    await assertFails(
      setDoc(doc(alice(), 'users/alice/settings/other'), pricingRules()),
    );
  });

  test('rejects out-of-range or unknown rule values', async () => {
    const invalid = [
      { markupPercent: 501 },
      { markupPercent: -91 },
      { taxPercent: 101 },
      { rounding: 'bankers' },
      { extra: true },
    ];
    for (const overrides of invalid) {
      await assertFails(setDoc(rulesDoc(alice()), pricingRules(overrides)));
    }
  });

  test("users cannot read someone else's pricing rules", async () => {
    await assertFails(getDoc(rulesDoc(bob(), 'alice')));
  });
});

describe('default deny', () => {
  test('unknown collections are closed', async () => {
    await assertFails(setDoc(doc(alice(), 'admin/config'), { open: true }));
    await assertFails(getDoc(doc(alice(), 'admin/config')));
  });
});
