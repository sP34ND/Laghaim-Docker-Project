#!/usr/bin/env node
/**
 * Laghaim SvrList.dta patcher
 *
 * Format (reverse-engineered from Game.exe):
 *   [0-3]   header: 00 00 0F 02  (max field len 15, server count 2)
 *   [4-18]  metadata (unchanged when patching IP)
 *   [10]    initial chain-cipher key byte
 *   [19..]  encrypted "Name IP Port" using chain subtract:
 *             cipher[0] = plain[0] + key0
 *             cipher[i] = plain[i] + cipher[i-1]  (mod 256)
 */
'use strict';

const fs = require('fs');
const path = require('path');

function chainDecrypt(buf, start, keyByte) {
  const out = [];
  let key = keyByte;
  for (let i = start; i < buf.length; i++) {
    const c = buf[i];
    out.push((c - key + 256) % 256);
    key = c;
  }
  return Buffer.from(out);
}

function chainEncrypt(str, keyByte) {
  const out = [];
  let key = keyByte;
  for (let i = 0; i < str.length; i++) {
    const p = str.charCodeAt(i);
    const c = (p + key) % 256;
    out.push(c);
    key = c;
  }
  return Buffer.from(out);
}

function usage() {
  console.log(`Usage: node svrlist-patch.js [ip] [port] [name] [inFile] [outFile]

Defaults:
  ip      127.0.0.1
  port    4015
  name    SavageEden
  inFile  ../Laghaim/SvrList.dta
  outFile same as inFile (backs up to .orig first)

Examples:
  node svrlist-patch.js
  node svrlist-patch.js 192.168.1.10 4015 "My Server"
  node svrlist-patch.js 127.0.0.1 4015 SavageEden SvrList.dta patched.dta
`);
}

function main() {
  const args = process.argv.slice(2);
  if (args.includes('-h') || args.includes('--help')) {
    usage();
    return;
  }

  const ip = args[0] || '127.0.0.1';
  const port = args[1] || '4015';
  const name = args[2] || 'SavageEden';
  const inFile = path.resolve(args[3] || path.join(__dirname, '..', 'Laghaim', 'SvrList.dta'));
  const outFile = path.resolve(args[4] || inFile);

  if (!fs.existsSync(inFile)) {
    console.error('File not found:', inFile);
    process.exit(1);
  }

  const orig = fs.readFileSync(inFile);
  if (orig.length < 20 || orig[2] !== 0x0f) {
    console.error('Unexpected SvrList.dta format');
    process.exit(1);
  }

  const keyByte = orig[10];
  const oldPlain = chainDecrypt(orig, 19, keyByte).toString('ascii').replace(/\0.*$/, '');
  const plain = `${name} ${ip} ${port}`;

  console.log('Input:  ', inFile);
  console.log('Key:    ', `0x${keyByte.toString(16)} (byte 10)`);
  console.log('Old:    ', JSON.stringify(oldPlain));
  console.log('New:    ', JSON.stringify(plain));

  const enc = chainEncrypt(plain, keyByte);
  const out = Buffer.concat([orig.slice(0, 19), enc]);

  const backup = inFile + '.orig';
  if (!fs.existsSync(backup)) {
    fs.copyFileSync(inFile, backup);
    console.log('Backup: ', backup);
  }

  if (outFile === inFile) {
    fs.writeFileSync(inFile, out);
    console.log('Patched:', inFile, `(${out.length} bytes)`);
  } else {
    fs.writeFileSync(outFile, out);
    console.log('Wrote:  ', outFile, `(${out.length} bytes)`);
  }

  const verify = chainDecrypt(out, 19, keyByte).toString('ascii').replace(/\0.*$/, '');
  console.log('Verify: ', JSON.stringify(verify));
}

main();
