from cryptography.hazmat.primitives.serialization import load_pem_public_key
from cryptography.hazmat.backends import default_backend

"""
!openssl x509 -in "openssl_cipher_cert.pem" -pubkey -noout > openssl_cipher_key.pub
!openssl x509 -in "openssl_sign_cert.pem" -pubkey -noout > openssl_sign_key.pub
"""

file_name = "openssl_cipher_key.pub"

with open(file_name, "rb") as f:
    pub_data = f.read()

pub_key = load_pem_public_key(pub_data, backend=default_backend())

# Example for RSA:
numbers = pub_key.public_numbers()

print(f"Modulus (n): {hex(numbers.n)}")
print(f"Public exponent (e): {hex(numbers.e)}")


from cryptography import x509
from cryptography.hazmat.backends import default_backend

file_name = "openssl_sign_cert.pem" # "openssl_sign_key.pub"
file_name = "openssl_cipher_cert.pem" # "openssl_cipher_key.pub"

with open(file_name, "rb") as f:
    cert_data = f.read()

cert = x509.load_pem_x509_certificate(cert_data, default_backend())

pub_key = cert.public_key()

# Now extract params similar to above
numbers = pub_key.public_numbers()
print(f"Modulus (n): {hex(numbers.n)}")  # for RSA
print(f"Exponent (e): {hex(numbers.e)}")

print("Issuer:", cert.issuer)
print("Subject:", cert.subject)
print("Serial Number:", cert.serial_number)
print("Validity:")
print("  Not Before:", cert.not_valid_before)
print("  Not After:", cert.not_valid_after)

"""
Modulus (n): 0xb2dfb98275ace1a227014eabc7c254d652464be43b336e0ff87353f30a75802e867a95014ee2d06381eccad762f512b8eb603908132ac2ae63dc743f2d04efaed231946fa3ed0b7eb18dc5c0871aa8d54434ab043c02e905a57fd6764440d4dbef5107844819580616edd016cd9c5e45f556d1990b5d38d7a419478fd85f68bd0538e1c6b5e729a3926d9c2c177dce43887045ffea61f0d3955eae59f553bbfb2293d0f663d6df85c1b315a7f1c172ee70fdcac896168a848082c94ebba3d681214a3fc397a02324a11e120690978534ec6d72f2b1f99be5ae6f38b10be9a2d8fbadbc4c4ae669c678ae6ee40d51b99359a2ba4456c722737ae4dbe37e8db051b34d730d59217d8d4581dc07af78f0dca1d369376d11215c3a86147b31a23d848cc23a06bb52a2f098d0747676b3427ac7644ce4e1a31636d785a844cba63c265bae689f94fd3b1245513480b661fc1d9af4d6cb355bd540a3e2133dd8346c8659601ec6b75acb70474d8afa122b72732b596196f62035ca787897098f56607089c44288f91b4afdbdd5eb1e204b056af093722dee4aecabb57917d305ef15d30872ce09557923df2f2e8c9f62530ac36caac79ea0cd7c8491db447e434acad7198e2dfd18c6e617344eadfc52dff6b75c427747ea18ef17da9a682f2edb23f52061a8c8a28206c91be4ae3476a72035bc866929ef02ef8bd09db42abc6b5725
Public exponent (e): 0x10001
Modulus (n): 0xb2dfb98275ace1a227014eabc7c254d652464be43b336e0ff87353f30a75802e867a95014ee2d06381eccad762f512b8eb603908132ac2ae63dc743f2d04efaed231946fa3ed0b7eb18dc5c0871aa8d54434ab043c02e905a57fd6764440d4dbef5107844819580616edd016cd9c5e45f556d1990b5d38d7a419478fd85f68bd0538e1c6b5e729a3926d9c2c177dce43887045ffea61f0d3955eae59f553bbfb2293d0f663d6df85c1b315a7f1c172ee70fdcac896168a848082c94ebba3d681214a3fc397a02324a11e120690978534ec6d72f2b1f99be5ae6f38b10be9a2d8fbadbc4c4ae669c678ae6ee40d51b99359a2ba4456c722737ae4dbe37e8db051b34d730d59217d8d4581dc07af78f0dca1d369376d11215c3a86147b31a23d848cc23a06bb52a2f098d0747676b3427ac7644ce4e1a31636d785a844cba63c265bae689f94fd3b1245513480b661fc1d9af4d6cb355bd540a3e2133dd8346c8659601ec6b75acb70474d8afa122b72732b596196f62035ca787897098f56607089c44288f91b4afdbdd5eb1e204b056af093722dee4aecabb57917d305ef15d30872ce09557923df2f2e8c9f62530ac36caac79ea0cd7c8491db447e434acad7198e2dfd18c6e617344eadfc52dff6b75c427747ea18ef17da9a682f2edb23f52061a8c8a28206c91be4ae3476a72035bc866929ef02ef8bd09db42abc6b5725
Exponent (e): 0x10001
Issuer: <Name(CN=OpenSSL Cipher Key,O=BIST,C=US)>
Subject: <Name(CN=OpenSSL Cipher Key,O=BIST,C=US)>
Serial Number: 344394152794422980344302767633304696650408198195
Validity:
  Not Before: 2025-06-10 17:08:21
  Not After: 2026-06-10 17:08:21
<ipython-input-28-4044978706>:41: CryptographyDeprecationWarning: Properties that return a naïve datetime object have been deprecated. Please switch to not_valid_before_utc.
  print("  Not Before:", cert.not_valid_before)
<ipython-input-28-4044978706>:42: CryptographyDeprecationWarning: Properties that return a naïve datetime object have been deprecated. Please switch to not_valid_after_utc.
  print("  Not After:", cert.not_valid_after)
""" 
