#!/bin/bash

# Set these variables to match your admin user.
# To generate the password hash, from a machine running Linux do:
#   $ openssl passwd -6
# openssl on macOS cannot generate SHA-512 passwords. You can generate a less
# secure MD5 password hash with the following:
#   $ openssl passwd -1
USERNAME='user'
PASSWORD='$6$l.AzX9/LpLLXAYVK$GPmU5u34ei1Ezehe6M3zrBBcM9HBbBnp.Xxk2RHSYRuwtSUgveOgVeiB0RnL8o3kzmVNert177qaefNQe8Q9J1'

# Allow SSH and enable the firewall
ufw allow OpenSSH
ufw --force enable

# Create the user, set shell to bash, and give sudo access
useradd -s /bin/bash -m -p $PASSWORD $USERNAME
usermod -aG sudo $USERNAME

# Copy the authorized_keys from root to the user, and set ownership
mkdir /home/$USERNAME/.ssh
cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh
chown -R $USERNAME: /home/$USERNAME/.ssh
chmod 0700 /home/$USERNAME/.ssh

# Disallow root logins via SSH, and restart SSH
sed -i 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh