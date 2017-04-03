echo "sneha ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
chown -R sneha:sneha /opt
chown -R sneha:sneha /home/sneha/opt
chown -R sneha:sneha /home/sneha/.ssh