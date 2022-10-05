
https://github.com/hashicorp/vagrant/issues/9836


## Steps to workaround

1. Add line to vagrant file:
    
    ```ruby
    config.vm.provision "shell", inline: "yum install -y kernel-devel"
    ```

2. Vagrant up. Encounter error.

3. Vagrant up once again to continue.

4. Vagrant reload.

5. Vagrant ssh to the machine.

6. Check vboxadd.service status:
    
    ```bash
    systemctl status vboxadd.service
    ```

7. If everything works fine, mount folder manually:

   ```bash
   sudo mount -t vboxsf -o uid=1000,gid=1000 home_ansible /home/ansible
   ```
