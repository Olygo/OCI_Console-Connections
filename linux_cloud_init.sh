#cloud-config
users:
 - default
 - name: recovery
   sudo: ALL=(ALL) NOPASSWD:ALL
   lock_passwd: false
   passwd: copy_your_password_hash_here_without_quotes