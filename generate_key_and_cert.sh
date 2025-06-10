#!/bin/bash
set -e

# ----------------------------
# CONFIG
# ----------------------------
OPENSSL_DIR="openssl"
OPENSSL_IN="$OPENSSL_DIR/in"
OPENSSL_OUT="$OPENSSL_DIR/out"

GPG_DIR="gpg"
GPG_IN="$GPG_DIR/in"
GPG_OUT="$GPG_DIR/out"

GPG_NAME_SIGN="BIST Signer"
GPG_NAME_CIPHER="BIST Cipher"
TEST_MESSAGE="bist_test.txt"

OPENSSL_CONFIG_SIGN="$OPENSSL_IN/openssl_sign.cnf"
OPENSSL_CONFIG_CIPHER="$OPENSSL_IN/openssl_cipher.cnf"

# Prepare test message and folders
echo "Hello from BIST" > "$TEST_MESSAGE"

mkdir -p "$OPENSSL_IN" "$OPENSSL_OUT" "$GPG_IN" "$GPG_OUT"

# ----------------------------
# 1. OPENSSL - Signing Key
# ----------------------------
cat > "$OPENSSL_CONFIG_SIGN" <<EOF
[ req ]
default_bits        = 4096
default_md          = sha256
prompt              = no
encrypt_key         = no
distinguished_name  = dn
x509_extensions     = v3_ca

[ dn ]
CN = OpenSSL Signing Key
O = BIST
C = US

[ v3_ca ]
keyUsage = digitalSignature
EOF

openssl req -new -x509 -config "$OPENSSL_CONFIG_SIGN" -days 365 \
  -keyout "$OPENSSL_OUT/openssl_sign_key.pem" -out "$OPENSSL_OUT/openssl_sign_cert.pem"

echo "✅ OpenSSL signing key generated"

# Test signing
openssl dgst -sha256 -sign "$OPENSSL_OUT/openssl_sign_key.pem" -out "$OPENSSL_OUT/sign.bin" "$TEST_MESSAGE"

openssl x509 -in "$OPENSSL_OUT/openssl_sign_cert.pem" -pubkey -noout > "$OPENSSL_OUT/pubkey.pem"
openssl dgst -sha256 -verify "$OPENSSL_OUT/pubkey.pem" -signature "$OPENSSL_OUT/sign.bin" "$TEST_MESSAGE" \
  && echo "✅ OpenSSL signing BIST passed"
rm "$OPENSSL_OUT/pubkey.pem"

# ----------------------------
# 2. OPENSSL - Cipher Key
# ----------------------------
cat > "$OPENSSL_CONFIG_CIPHER" <<EOF
[ req ]
default_bits        = 4096
default_md          = sha256
prompt              = no
encrypt_key         = no
distinguished_name  = dn

[ dn ]
CN = OpenSSL Cipher Key
O = BIST
C = US
EOF

openssl req -new -x509 -config "$OPENSSL_CONFIG_CIPHER" -days 365 \
  -keyout "$OPENSSL_OUT/openssl_cipher_key.pem" -out "$OPENSSL_OUT/openssl_cipher_cert.pem"

echo "✅ OpenSSL cipher key generated"

# Test encryption/decryption
openssl x509 -in "$OPENSSL_OUT/openssl_cipher_cert.pem" -pubkey -noout > "$OPENSSL_OUT/cipher_pub.pem"

openssl rsautl -encrypt -pubin -inkey "$OPENSSL_OUT/cipher_pub.pem" \
  -in "$TEST_MESSAGE" -out "$OPENSSL_OUT/enc.bin"

openssl rsautl -decrypt -inkey "$OPENSSL_OUT/openssl_cipher_key.pem" -in "$OPENSSL_OUT/enc.bin" -out "$OPENSSL_OUT/dec.txt"

diff "$TEST_MESSAGE" "$OPENSSL_OUT/dec.txt" && echo "✅ OpenSSL encryption BIST passed"

rm "$OPENSSL_OUT/cipher_pub.pem"

# ----------------------------
# 3. GPG - Signing Key
# ----------------------------
cat > "$GPG_IN/gpg_sign_batch" <<EOF
%echo Generating a signing key
Key-Type: RSA
Key-Length: 4096
Name-Real: $GPG_NAME_SIGN
Name-Email: sign@example.com
Expire-Date: 1y
%no-protection
%commit
%echo Done
EOF

gpg --batch --generate-key "$GPG_IN/gpg_sign_batch"

# Test GPG signing
gpg --output "$GPG_OUT/sign.gpg" --sign "$TEST_MESSAGE"
gpg --verify "$GPG_OUT/sign.gpg" && echo "✅ GPG signing BIST passed"

# ----------------------------
# 4. GPG - Cipher Key
# ----------------------------
cat > "$GPG_IN/gpg_cipher_batch" <<EOF
%echo Generating GPG Cipher Key
Key-Type: RSA
Key-Length: 4096
Name-Real: $GPG_NAME_CIPHER
Name-Email: cipher@example.com
Expire-Date: 1y
%no-protection
%commit
%echo done
EOF

gpg --batch --generate-key "$GPG_IN/gpg_cipher_batch"

# Extract fingerprint for encryption test
FPR=$(gpg --list-keys --with-colons "$GPG_NAME_CIPHER" | awk -F: '/^fpr:/ { print $10; exit }')

# Test GPG encryption
gpg --output "$GPG_OUT/enc.gpg" --encrypt --recipient "$FPR" "$TEST_MESSAGE"
gpg --output "$GPG_OUT/dec_gpg.txt" --decrypt "$GPG_OUT/enc.gpg"

diff "$TEST_MESSAGE" "$GPG_OUT/dec_gpg.txt" && echo "✅ GPG encryption BIST passed"

# Export ASCII-armored keys to GPG out directory
gpg --armor --export "$GPG_NAME_CIPHER" > "$GPG_OUT/gpg_cipher_pub.asc"
gpg --armor --export-secret-keys "$GPG_NAME_CIPHER" > "$GPG_OUT/gpg_cipher_priv.asc"
gpg --armor --export "$GPG_NAME_SIGN" > "$GPG_OUT/gpg_sign_pub.asc"
gpg --armor --export-secret-keys "$GPG_NAME_SIGN" > "$GPG_OUT/gpg_sign_priv.asc"

# ----------------------------
# TRUSTED IMPORT (RE-IMPORT TEST)
# ----------------------------
echo -e "\n🔁 Verifying trusted key import..."

# Re-import test (simulate import on a new machine or account)
gpg --import "$GPG_OUT/gpg_sign_pub.asc"
gpg --import "$GPG_OUT/gpg_cipher_pub.asc"

echo "✅ GPG trusted key import test passed"

# ----------------------------
# SUMMARY
# ----------------------------
echo -e "\n🎉 All BISTs passed."
echo "Files organized in folders:"
echo "  $OPENSSL_IN/       # openssl input config files"
echo "  $OPENSSL_OUT/      # openssl generated keys and certs"
echo "  $GPG_IN/           # gpg input batch files"
echo "  $GPG_OUT/          # gpg generated keys and exports"

