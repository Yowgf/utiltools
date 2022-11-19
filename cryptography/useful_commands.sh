
# Display given key
openssl pkey -text -in <pkey.pem>

# Display given certificate
openssl x509 -text -nocert -in <cert.pem>

# Generate 256-bit key using a lot of crazy stuff. Use the PBKDF2 key derivation
# algorithm to generate the key from the password. Apply SHA1 hash before
# inputting to AES + CBC.
#
# Remeber to set $password before running command.
openssl enc -aes-256-cbc -P -md sha1 -pbkdf2 -k $password
