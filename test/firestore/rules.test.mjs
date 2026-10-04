import {readFileSync} from 'node:fs';
import {after, before, beforeEach, test} from 'node:test';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {doc, collection, getDoc, getDocs, setDoc, updateDoc, serverTimestamp} from 'firebase/firestore';

let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-bookswap', firestore: {rules: readFileSync('../../firestore.rules', 'utf8')}});
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());
const profile = (extra = {}) => ({
  email: 'sam@gmail.com', firstName: 'Sam', lastName: 'Reader', gender: 'Prefer not to say',
  mobile: '+8801712345678', address: 'Gazipur', preferences: ['Fiction'], favoriteBook: '',
  acceptedTermsVersion: '1.1', acceptedTermsAt: serverTimestamp(), ...extra,
});
const dbFor = (verified = false, uid = 'sam') => env.authenticatedContext(uid, {email: `${uid}@gmail.com`, email_verified: verified}).firestore();

test('pending accounts can save and read only their own valid registration', async () => {
  const db = dbFor();
  await assertSucceeds(setDoc(doc(db, 'profiles/sam'), profile()));
  await assertSucceeds(getDoc(doc(db, 'profiles/sam')));
  await assertFails(getDoc(doc(dbFor(false, 'other'), 'profiles/sam')));
  await assertFails(getDocs(collection(db, 'profiles')));
  await assertFails(getDoc(doc(db, 'books/example')));
});
test('Google verification alone cannot access member content', async () => {
  await assertFails(getDoc(doc(dbFor(true), 'books/example')));
});
test('verified registered members can read member content', async () => {
  const db = dbFor(true);
  await assertSucceeds(setDoc(doc(db, 'profiles/sam'), profile()));
  await assertSucceeds(getDoc(doc(db, 'books/example')));
  await assertFails(setDoc(doc(db, 'books/example'), {title: 'Unsupported write'}));
});
test('clients cannot forge membership or rewrite consent', async () => {
  const db = dbFor();
  await assertFails(setDoc(doc(db, 'profiles/sam'), profile({emailVerified: true})));
  await assertFails(setDoc(doc(db, 'profiles/sam'), profile({email: 'other@gmail.com'})));
  await assertFails(setDoc(doc(db, 'profiles/other'), profile()));
  await assertSucceeds(setDoc(doc(db, 'profiles/sam'), profile()));
  await assertFails(updateDoc(doc(db, 'profiles/sam'), {acceptedTermsVersion: 'fake'}));
});
test('incomplete or invalid profiles and missing consent are rejected', async () => {
  const db = dbFor();
  for (const override of [{firstName: ''}, {preferences: []}, {preferences: ['Invalid']}, {mobile: '----------'}, {acceptedTermsVersion: ''}, {acceptedTermsAt: new Date(0)}]) {
    await assertFails(setDoc(doc(db, 'profiles/sam'), profile(override)));
  }
  await assertFails(setDoc(doc(db, 'profiles/sam'), {email: 'sam@gmail.com'}));
});
test('signed-out users cannot read profiles or member content', async () => {
  const db = env.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(db, 'profiles/sam')));
  await assertFails(getDoc(doc(db, 'books/example')));
  await assertFails(setDoc(doc(db, 'profiles/sam'), profile()));
});
