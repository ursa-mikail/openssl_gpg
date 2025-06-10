#!/bin/bash
set -e

# ----------------------------
# CONFIG
# ----------------------------
GPG_IMPORT_DIR="gpg/import"
GPG_TEMP_DIR="gpg/temp"
TEST_MESSAGE="$GPG_TEMP_DIR/test_message.txt"
TEST_SIGNATURE="$GPG_TEMP_DIR/test_signature.asc"
TEST_ENCRYPTED="$GPG_TEMP_DIR/encrypted.gpg"
TEST_DECRYPTED="$GPG_TEMP_DIR/decrypted.txt"

# GPG identity
GPG_NAME="BIST Signer"
GPG_EMAIL="sign@example.com"
PUBKEY_FILE="$GPG_IMPORT_DIR/gpg_sign_pub.asc"

# Ensure required directories exist
mkdir -p "$GPG_IMPORT_DIR" "$GPG_TEMP_DIR"

# ----------------------------
# Generate GPG Key if Missing
# ----------------------------
generate_gpg_key_if_needed() {
  if [[ -f "$PUBKEY_FILE" ]]; then
    echo "📎 Public key already exists at $PUBKEY_FILE"
    return
  fi

  echo "❗ Public key not found. Generating new GPG keypair for '$GPG_NAME <$GPG_EMAIL>'..."

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

  echo "📤 Exporting public key to $PUBKEY_FILE"
  gpg --armor --export "$GPG_NAME" > "$PUBKEY_FILE"
}

# ----------------------------
# 1. IMPORT GPG KEY
# ----------------------------
import_gpg_key() {
  local key_file="$1"
  echo "📥 Importing GPG key from: $key_file"
  gpg --import "$key_file"
}

# ----------------------------
# 2. ENCRYPT FILE WITH IMPORTED KEY
# ----------------------------
encrypt_with_gpg_key() {
  local recipient="$1"
  local input_file="$2"
  local output_file="$3"
  echo "🔐 Encrypting file for recipient: $recipient"
  gpg --output "$output_file" --encrypt --recipient "$recipient" "$input_file"
}

# ----------------------------
# 3. VERIFY GPG SIGNATURE
# ----------------------------
verify_gpg_signature() {
  local signed_file="$1"
  local original_file="$2"
  echo "🧾 Verifying signature on: $signed_file"
  gpg --verify "$signed_file" "$original_file"
}

# ----------------------------
# 4. BIST: DEMO IMPORT, ENCRYPT, VERIFY SIGNATURE
# ----------------------------
run_gpg_bist_demo() {
  echo "🧪 Running GPG BIST Demo"

  # Step 0: Ensure folders and message exist
  echo "📁 Ensuring folder structure:"
  echo "gpg/"
  echo "├── import/"
  echo "│   └── gpg_sign_pub.asc         # Public key will be created if missing"
  echo "├── temp/"
  echo "    └── test_signature.asc       # Optional: will be generated if missing"
  echo

  echo "📄 Creating test message: $TEST_MESSAGE"
  echo "Hello GPG BIST" > "$TEST_MESSAGE"

  # Step 1: Ensure public key exists (generate if needed)
  generate_gpg_key_if_needed

  # Step 2: Import the public key
  import_gpg_key "$PUBKEY_FILE"

  # Step 3: Encrypt the message
  encrypt_with_gpg_key "$GPG_NAME" "$TEST_MESSAGE" "$TEST_ENCRYPTED"

  # Step 4: Decrypt and compare
  gpg --output "$TEST_DECRYPTED" --decrypt "$TEST_ENCRYPTED"
  diff "$TEST_MESSAGE" "$TEST_DECRYPTED" && echo "✅ GPG encryption test passed"

  # Step 5: Generate test signature if missing
  if [[ ! -f "$TEST_SIGNATURE" ]]; then
    echo "🖊️  Creating test signature..."
    gpg --output "$TEST_SIGNATURE" --armor --sign "$TEST_MESSAGE"
  fi

  # Step 6: Verify signature
  verify_gpg_signature "$TEST_SIGNATURE" "$TEST_MESSAGE" && echo "✅ GPG signature verification passed"

  echo -e "\n🎉 BIST completed successfully."
}

# ----------------------------
# Execute BIST if script run directly
# ----------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_gpg_bist_demo
fi
