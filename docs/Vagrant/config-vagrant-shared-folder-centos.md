## Install vbguest plugin

```
    vagrant plugin install vagrant-vbguest
```

## Can't auto install Virtualbox Guest Additions

```
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
```

1. run up virtualbox vm
2. connect on vm
3. execute following commands:
```bash
    yum update -y
    yum install -y gcc make kernel-devel
```
4. restart virtualbox vm, then it will auto install vbguest additions


```
bribin.zheng@XMN113 /c/VMs/Mesos
$ vagrant.exe up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'centos/7' is up to date...
==> default: A newer version of the box 'centos/7' is available! You currently
==> default: have version '1607.01'. The latest is version '1611.01'. Run
==> default: `vagrant box update` to update.
==> default: Clearing any previously set forwarded ports...
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2200 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Machine booted and ready!
[default] No installation found.
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.163.com
 * extras: mirrors.163.com
 * updates: mirrors.163.com
Package gcc-4.8.5-11.el7.x86_64 already installed and latest version
Package binutils-2.25.1-22.base.el7.x86_64 already installed and latest version
Package 1:make-3.82-23.el7.x86_64 already installed and latest version
Package 4:perl-5.16.3-291.el7.x86_64 already installed and latest version
Package bzip2-1.0.6-13.el7.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package kernel-devel.x86_64 0:3.10.0-514.6.1.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package            Arch         Version                    Repository     Size
================================================================================
Installing:
 kernel-devel       x86_64       3.10.0-514.6.1.el7         updates        13 M

Transaction Summary
================================================================================
Install  1 Package

Total download size: 13 M
Installed size: 34 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : kernel-devel-3.10.0-514.6.1.el7.x86_64                       1/1
  Verifying  : kernel-devel-3.10.0-514.6.1.el7.x86_64                       1/1

Installed:
  kernel-devel.x86_64 0:3.10.0-514.6.1.el7

Complete!
Copy iso file C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso into the box /tmp/VBoxGuestAdditions.iso
mount: /dev/loop0 is write-protected, mounting read-only
Installing Virtualbox Guest Additions 5.1.12 - guest version is unknown
Verifying archive integrity... All good.
Uncompressing VirtualBox 5.1.12 Guest Additions for Linux...........
VirtualBox Guest Additions installer
Removing installed version 5.1.12 of VirtualBox Guest Additions...
Copying additional installer modules ...
Installing additional modules ...
vboxadd.sh: Building Guest Additions kernel modules.
vboxadd.sh: Starting the VirtualBox Guest Additions.

Could not find the X.Org or XFree86 Window System, skipping.
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => C:/VMs/Mesos
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.

bribin.zheng@XMN113 /c/VMs/Mesos
```
