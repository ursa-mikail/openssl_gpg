


❌ You cannot directly import an OpenSSL-generated RSA keypair into GPG for use as an OpenPGP key, because GPG uses its own OpenPGP format, which is not the same as X.509/PKCS standards used by OpenSSL.

| Task                          | Tool         | Notes                                         |
| ----------------------------- | ------------ | --------------------------------------------- |
| Generate 4096-bit RSA keypair | OpenSSL      | Done via config                               |
| Make certificate valid 1 year | OpenSSL      | `-days 365`                                   |
| Export in DER (binary) format | OpenSSL      | Required for import                           |
| Convert to OpenPGP format     | GPG (manual) | Not automatic – better to use `gpg --gen-key` |
| Use key for GPG operations    | GPG          | Prefer GPG-native keys                        |


| Step | Action                                     | Tool    |
| ---- | ------------------------------------------ | ------- |
| 1    | Generate OpenSSL RSA 4096 signing key      | OpenSSL |
| 2    | Sign a file and verify signature           | OpenSSL |
| 3    | Generate OpenSSL RSA 4096 encryption key   | OpenSSL |
| 4    | Encrypt/decrypt a file with public/private | OpenSSL |
| 5    | Generate GPG RSA 4096 signing key          | GnuPG   |
| 6    | Sign and verify a file                     | GnuPG   |
| 7    | Generate GPG RSA 4096 encryption key       | GnuPG   |
| 8    | Encrypt/decrypt a file                     | GnuPG   |

## 📂 trusted_keys/ folder will contain:

| File                      | Purpose                      |
| ------------------------- | ---------------------------- |
| `gpg_sign_pub.asc`        | GPG signing public key       |
| `gpg_sign_priv.asc`       | GPG signing private key      |
| `gpg_cipher_pub.asc`      | GPG encryption public key    |
| `gpg_cipher_priv.asc`     | GPG encryption private key   |
| `openssl_sign_cert.pem`   | OpenSSL signing cert (X.509) |
| `openssl_cipher_cert.pem` | OpenSSL encryption cert      |



Output:

```
% tree .
.
├── bist_test.txt
├── generate_key_and_cert.sh
├── gpg
│   ├── in
│   │   ├── gpg_cipher_batch
│   │   └── gpg_sign_batch
│   └── out
│       ├── dec_gpg.txt
│       ├── enc.gpg
│       ├── gpg_cipher_priv.asc
│       ├── gpg_cipher_pub.asc
│       ├── gpg_sign_priv.asc
│       ├── gpg_sign_pub.asc
│       └── sign.gpg
├── openssl
│   ├── in
│   │   ├── openssl_cipher.cnf
│   │   └── openssl_sign.cnf
│   └── out
│       ├── dec.txt
│       ├── enc.bin
│       ├── openssl_cipher_cert.pem
│       ├── openssl_cipher_key.pem
│       ├── openssl_sign_cert.pem
│       ├── openssl_sign_key.pem
│       └── sign.bin
└── readme.md


```


```
% ./generate_key_and_cert.sh
.......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.....+...+.......+......+.........+.....+.........+....+..+.+...+..+.......+........+.......+...............+..+.........+......+.+...+..+..........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*...................+.....+....+.....+.+..+...+...+....+...+...+..+...+......+....+..+.......+..+....+....................+................+.....+......+...+....+..+...+............+.+.....+...............+..................+.+.........+......+......+..............+.+........+.......+........+........................+.......+...........+.......+...........+.+.....+........................+....+...........+.+...+..+...................+..............+......+...................+...+........+.+...........+....+..............+....+........+..........+..+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
......+..+.......+.....+.+..+.......+...+..+....+...........+.............+..+...+...+....+...+...........+.+..............+.........+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.....+.+..+...+.+..............+.+.....+.+....................+....+.....+...+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*...+.......+.....+.......+..................+...+.........+...........+......+......+....+...........+.............+..............+.+.................+..........+.....+............+.......+......+...+..+....+........+...+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
✅ OpenSSL signing key generated
Verified OK
✅ OpenSSL signing BIST passed
.+.....+.+.....+......+....+........+...+...+......+.+...+............+.....+.......+..+....+.....+....+......+.....+......+...+......+......+...+.......+...+...+........+.+.....+....+..+.......+......+..+.......+...........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.+.......+........+.......+.....+.+.....+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.+...............+.+........+......+.......+..+.+......+..............+......+.........................+...+........+...+............+.......+..+...+............+....+..+...+...............+...........................+....+........+...+.............+.....+....+.....+..................+...+....+..+...+.............+.....+...+..........+..+....+.....+....+......+...+...............+..+...+...............+.......+...........+.........+.............+........+.........+....+.........+.....................+......+.....+.+.........+......+........+.+.........+..+.......+......+..............+.+..+.............+..............+.......+.....+......+....+......+..+...+.......+...+...............+...+...........+...+.+...............+..+....+.....+.+...+...........+.+.........+...+..+...+......+.......+...+..+.........+.+..+..........+.....+...+....+...+...............+.....+.......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.....+.........+...+..+................+..+..........+.....+....+.....+...+............+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*...+.........+......+......+.+...+..+............+.......+.....+....+.....+....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.......+.....+.+...+....................+....+..+.........+............+....+.....+...+.+..+...+..........+......+........+.+.....+............+.......+...+..+..........+..+......+...+......+...............+...+...+.......+......+.........+..................+.......................+......+......+...+....+..+.+..+.+..............+...+....+...........+....+......+..+.+......+...............+.....+.........+.......+...+...........+...+.+......+........+..........+...+...+.....+.........+.............+.........+......+..+.......+..................+...+..+............+................+............+...+..+......+.......+........+............+.............+.................+....+...........+...+....+...........+.+...............+......+..+.............+....................+...+.........+......................+........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
✅ OpenSSL cipher key generated
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
✅ OpenSSL encryption BIST passed
gpg: Generating a signing key
gpg: revocation certificate stored as '/Users/.gnupg/openpgp-revocs.d/C2ED79A5F1A6EC2C3D8B56DE7EA5EEF93B2E8374.rev'
gpg: Done
gpg: Signature made Tue Jun 10 10:01:01 2025 PDT
gpg:                using RSA key 0A627B97663F8AF12ADE83FDEA060A34D72D8B8A
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:  10  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 10u
gpg: next trustdb check due at 2026-06-10
gpg: Good signature from "BIST Signer <sign@example.com>" [ultimate]
✅ GPG signing BIST passed
gpg: Generating GPG Cipher Key
gpg: revocation certificate stored as '/Users/.gnupg/openpgp-revocs.d/EB57FA5D1C0B5020EF4A136EF8DB339C89239BB2.rev'
gpg: done
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:  11  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 11u
gpg: next trustdb check due at 2026-06-10
gpg: encrypted with rsa4096 key, ID 58AB599DB4197040, created 2025-06-10
      "BIST Cipher <cipher@example.com>"
✅ GPG encryption BIST passed

🔁 Verifying trusted key import...
gpg: key EA060A34D72D8B8A: "BIST Signer <sign@example.com>" not changed
gpg: key C414708DA36DF54C: "BIST Signer <sign@example.com>" not changed
gpg: key 0D3A07516428D2B6: "BIST Signer <sign@example.com>" not changed
gpg: key 8DC9539994934AD9: "BIST Signer <sign@example.com>" not changed
gpg: key 41B59C975F8F49B6: "BIST Signer <sign@example.com>" not changed
gpg: key 7EA5EEF93B2E8374: "BIST Signer <sign@example.com>" not changed
gpg: Total number processed: 6
gpg:              unchanged: 6
gpg: key 58AB599DB4197040: "BIST Cipher <cipher@example.com>" not changed
gpg: key A174B61B37BE2010: "BIST Cipher <cipher@example.com>" not changed
gpg: key 3F0075DED29422B7: "BIST Cipher <cipher@example.com>" not changed
gpg: key 340B63AD6035F2E4: "BIST Cipher <cipher@example.com>" not changed
gpg: key F8DB339C89239BB2: "BIST Cipher <cipher@example.com>" not changed
gpg: Total number processed: 5
gpg:              unchanged: 5
✅ GPG trusted key import test passed

🎉 All BISTs passed.
Trusted keys exported to: trusted_keys
 % ./generate_key_and_cert.sh
.+...+.+...+.....+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*....+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+..+....+...+...+..............+.+.................+......+....+......+............+..+...+.........+......+.............+.....+.........+.......+..............+....+........+...+.+...........+.........+.+...+...........+....+......+.........+...........+.........+......+.+..+.......+........+...+........................+...+...+....+.....+...+.+.........+...+........+.......+...+...............+......+.....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
......+.+..+.+.....+............+.........+.+..+......+....+..+.+...+.........+........+.........+...+...+....+.........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.....+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+......+...+............+.........+....+..+..........+...........+....+......+...............+...+......+...........+.........+.+..+......+.....................+.............+..+...+...+.......+......+.....+......+.+.........+......+....................+....+.....+.............+............+...........+...+....+...+..............+...+......+..........+......+...+...........+....+......+..+...+......+.+..+.+.........+..+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
✅ OpenSSL signing key generated
Verified OK
✅ OpenSSL signing BIST passed
.+.+...+...+............+.....+......+.+......+...+..+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*......+...+............+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.......+...........................+...+.......+...+..+...+.............+...........+....+.........+.....+.+..+.............+......+...+...+..............+.+..+.......+.....+.+..............+..................+.+.....................+........+.+.....+.+...+..+................+........+.+...+..+.+..+...+.........+....+...............+......+.....+......+....+.........+.....+......+....+.....+.......+...+....................+.+..............+.........+................+..+.............+.........+.....+.......+......+..+.............+.....+.......+..+....+.....+......+....+.........+..+................+...............+..+.+...........+.+..+..........+...+.........+..............................+.....+....+..............+...+............+.+.....+...........................+..........+...............+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
......+...+.+..+..........+...............+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+.+.....+...+......+.+.....+..........+.........+.....+....+..+....+..............+.+......+..+......+......+.+..+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*........+..........................+..........+......+........+...+.........+.........+.+.....+....+..+.........+.+..+.+......+...+....................+.......+.........+.....+.+........+.+.....+......................+...............+..+.+......+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
✅ OpenSSL cipher key generated
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
✅ OpenSSL encryption BIST passed
gpg: Generating a signing key
gpg: revocation certificate stored as '/Users/.gnupg/openpgp-revocs.d/AA521139C9A5223EF5CF33FF6EA2807DA7FCFC42.rev'
gpg: Done
gpg: Signature made Tue Jun 10 10:05:42 2025 PDT
gpg:                using RSA key 0A627B97663F8AF12ADE83FDEA060A34D72D8B8A
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:  12  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 12u
gpg: next trustdb check due at 2026-06-10
gpg: Good signature from "BIST Signer <sign@example.com>" [ultimate]
✅ GPG signing BIST passed
gpg: Generating GPG Cipher Key
gpg: revocation certificate stored as '/Users/.gnupg/openpgp-revocs.d/4C2E669AC1A35516F8CA911480B707260DA9B4A9.rev'
gpg: done
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:  13  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 13u
gpg: next trustdb check due at 2026-06-10
gpg: encrypted with rsa4096 key, ID 58AB599DB4197040, created 2025-06-10
      "BIST Cipher <cipher@example.com>"
✅ GPG encryption BIST passed

🔁 Verifying trusted key import...
gpg: key EA060A34D72D8B8A: "BIST Signer <sign@example.com>" not changed
gpg: key C414708DA36DF54C: "BIST Signer <sign@example.com>" not changed
gpg: key 0D3A07516428D2B6: "BIST Signer <sign@example.com>" not changed
gpg: key 8DC9539994934AD9: "BIST Signer <sign@example.com>" not changed
gpg: key 6EA2807DA7FCFC42: "BIST Signer <sign@example.com>" not changed
gpg: key 41B59C975F8F49B6: "BIST Signer <sign@example.com>" not changed
gpg: key 7EA5EEF93B2E8374: "BIST Signer <sign@example.com>" not changed
gpg: Total number processed: 7
gpg:              unchanged: 7
gpg: key 58AB599DB4197040: "BIST Cipher <cipher@example.com>" not changed
gpg: key A174B61B37BE2010: "BIST Cipher <cipher@example.com>" not changed
gpg: key 80B707260DA9B4A9: "BIST Cipher <cipher@example.com>" not changed
gpg: key 3F0075DED29422B7: "BIST Cipher <cipher@example.com>" not changed
gpg: key 340B63AD6035F2E4: "BIST Cipher <cipher@example.com>" not changed
gpg: key F8DB339C89239BB2: "BIST Cipher <cipher@example.com>" not changed
gpg: Total number processed: 6
gpg:              unchanged: 6
✅ GPG trusted key import test passed

🎉 All BISTs passed.
Files organized in folders:
  openssl/in/       # openssl input config files
  openssl/out/      # openssl generated keys and certs
  gpg/in/           # gpg input batch files
  gpg/out/          # gpg generated keys and exports

```

## gpg_util.sh

To use a GPG utility script in Bash that:

1. Imports a GPG key (public key expected in ASCII-armored .asc format)
2. Encrypts a file with that key
3. Verifies a signature made with that key

It includes a BIST (Built-In Self Test) function at the bottom to demonstrate and validate these steps.

```
.
├── generate_gpg_test_key.sh
├── gpg
│     ├── import
│     │     └── gpg_sign_pub.asc
│     └── temp
│           ├── decrypted.txt
│           ├── encrypted.gpg
│           ├── test_message.txt
│           └── test_signature.asc
└── gpg_util.sh


```

Output:

```
% ./gpg_util.sh
🧪 Running GPG BIST Demo
🔧 Generating GPG key for: BIST Signer <sign@example.com>
gpg: Generating test GPG key
gpg: revocation certificate stored as '/Users/.gnupg/openpgp-revocs.d/53FE9B895CBA36E95597CC58D736338FC358C00F.rev'
gpg: done
📤 Exporting public key to gpg/import/gpg_sign_pub.asc
✅ GPG key generation complete.
📁 Ensuring folder structure:
gpg/
├── import/
│   └── gpg_sign_pub.asc         # ASCII-armored public key
├── temp/
    └── test_signature.asc       # Optional: will be generated if missing

📥 Importing GPG key from: gpg/import/gpg_sign_pub.asc
gpg: key EA060A34D72D8B8A: "BIST Signer <sign@example.com>" not changed
gpg: key C414708DA36DF54C: "BIST Signer <sign@example.com>" not changed
gpg: key 0D3A07516428D2B6: "BIST Signer <sign@example.com>" not changed
gpg: key D736338FC358C00F: "BIST Signer <sign@example.com>" not changed
gpg: key 646B898195DE037D: "BIST Signer <sign@example.com>" not changed
gpg: key 8DC9539994934AD9: "BIST Signer <sign@example.com>" not changed
gpg: key 6EA2807DA7FCFC42: "BIST Signer <sign@example.com>" not changed
gpg: key 41B59C975F8F49B6: "BIST Signer <sign@example.com>" not changed
gpg: key 7EA5EEF93B2E8374: "BIST Signer <sign@example.com>" not changed
gpg: Total number processed: 9
gpg:              unchanged: 9
🔐 Encrypting file for recipient: BIST Signer
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:  16  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 16u
gpg: next trustdb check due at 2026-06-10
gpg: encrypted with rsa4096 key, ID EA060A34D72D8B8A, created 2025-06-10
      "BIST Signer <sign@example.com>"
✅ GPG encryption test passed
🖊️  Generating test signature...
🧾 Verifying signature on: gpg/temp/test_signature.asc
gpg: not a detached signature
-e 
🎉 BIST completed.
```

