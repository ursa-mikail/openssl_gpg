# chmod +x gpg_util.sh
# ./gpg_util.sh
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

# GPG identity for encryption/signing
GPG_RECIPIENT_NAME="BIST Signer"
GPG_SIGNER_EMAIL="sign@example.com"
PUBKEY_FILE="$GPG_IMPORT_DIR/gpg_sign_pub.asc"

# Ensure required directories exist
mkdir -p "$GPG_IMPORT_DIR" "$GPG_TEMP_DIR"

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
  chmod +x generate_gpg_test_key.sh
  ./generate_gpg_test_key.sh

  # Step 0: Ensure folders and input exist
  echo "📁 Ensuring folder structure:"
  echo "gpg/"
  echo "├── import/"
  echo "│   └── gpg_sign_pub.asc         # ASCII-armored public key"
  echo "├── temp/"
  echo "    └── test_signature.asc       # Optional: will be generated if missing"
  echo

  if [[ ! -f "$PUBKEY_FILE" ]]; then
    echo "❌ Public key not found at $PUBKEY_FILE"
    echo "➡️  Please place your GPG public key (ASCII-armored) at this location."
    exit 1
  fi

  echo "Hello GPG BIST" > "$TEST_MESSAGE"

  # Step 1: Import public key
  import_gpg_key "$PUBKEY_FILE"

  # Step 2: Encrypt file
  encrypt_with_gpg_key "$GPG_RECIPIENT_NAME" "$TEST_MESSAGE" "$TEST_ENCRYPTED"

  # Step 3: Decrypt to verify encryption works
  gpg --output "$TEST_DECRYPTED" --decrypt "$TEST_ENCRYPTED"
  diff "$TEST_MESSAGE" "$TEST_DECRYPTED" && echo "✅ GPG encryption test passed"

  # Step 4: Create test signature if not exists
  if [[ ! -f "$TEST_SIGNATURE" ]]; then
    echo "🖊️  Generating test signature..."
    gpg --output "$TEST_SIGNATURE" --armor --sign "$TEST_MESSAGE"
  fi

  # Step 5: Verify signed file
  verify_gpg_signature "$TEST_SIGNATURE" "$TEST_MESSAGE" && echo "✅ GPG signature verification passed"

  echo -e "\n🎉 BIST completed."
}

# Run the BIST if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_gpg_bist_demo
fi



