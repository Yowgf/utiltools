
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

# Example of downloading and configuring a GPG key for debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
# You can also manually edit the files in /etc/apt/sources.list.d
