# chmod +x generate_gpg_test_key.sh
# ./generate_gpg_test_key.sh

#!/bin/bash
set -e

# ----------------------------
# CONFIG
# ----------------------------
GPG_NAME="BIST Signer"
GPG_EMAIL="sign@example.com"
EXPORT_DIR="gpg/import"

mkdir -p "$EXPORT_DIR"

# ----------------------------
# Generate Key
# ----------------------------
echo "🔧 Generating GPG key for: $GPG_NAME <$GPG_EMAIL>"

cat > gpg_batch <<EOF
%echo Generating test GPG key
Key-Type: RSA
Key-Length: 4096
Name-Real: $GPG_NAME
Name-Email: $GPG_EMAIL
Expire-Date: 1y
%no-protection
%commit
%echo done
EOF

gpg --batch --generate-key gpg_batch
rm gpg_batch

# ----------------------------
# Export Public Key
# ----------------------------
echo "📤 Exporting public key to $EXPORT_DIR/gpg_sign_pub.asc"
gpg --armor --export "$GPG_NAME" > "$EXPORT_DIR/gpg_sign_pub.asc"

echo "✅ GPG key generation complete."

