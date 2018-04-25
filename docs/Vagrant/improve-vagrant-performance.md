## Improving Vagrant performance

https://www.mkwd.net/improve-vagrant-performance/


### Increasing allocated CPU cores and RAM in Vagrant

```ruby
Vagrant.configure(2) do |config|
    # ...
    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
    end
end
```

#### Use 1/4 system memory

```ruby
config.vm.provider "virtualbox" do |v|
  host = RbConfig::CONFIG['host_os']

  # Give VM 1/4 system memory 
  if host =~ /darwin/
    # sysctl returns Bytes and we need to convert to MB
    mem = `sysctl -n hw.memsize`.to_i / 1024
  elsif host =~ /linux/
    # meminfo shows KB and we need to convert to MB
    mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i 
  elsif host =~ /mswin|mingw|cygwin/
    # Windows code via https://github.com/rdsubhas/vagrant-faster
    mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
  end

  mem = mem / 1024 / 4
  v.customize ["modifyvm", :id, "--memory", mem]
end
```


### Solving slow download speeds in Vagrant/VirtualBox

```ruby
Vagrant.configure(2) do |config|
    # …
    config.vm.provider "virtualbox" do |v|
        # …
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
end
```

These 2 settings will force DNS requests by the VM to use the host DNS, rather than external DNS servers.


### Enabling multiple cores in Vagrant/VirtualBox

If you have assigned multiple CPU cores to VirtualBox in your Vagrantfile, you should also enable IO APIC so that the virtual machine can make use of the additional cores.
If you do not enable IO APIC, you may notice the virtual machine under performing, and using high amounts of CPU in the guest machine (because of lack of availability of the other cores).

```ruby
Vagrant.configure(2) do |config|
    # ...
    config.vm.provider "virtualbox" do |v|
        # ...
        v.customize ["modifyvm", :id, "--ioapic", "on"]
    end
end
```


### Faster folder synchronisation in Vagrant/VirtualBox

The default shared folder setup within Vagrant/VirtualBox can be slow. 
Enabling NFS on the shared folder can result in huge performance improvements, especially if your application utilises lots of disk caching (such as Symfony and Laravel). 

```ruby
Vagrant.configure("2") do |config|
    # ...
    config.vm.synced_folder ".", "/vagrant", type: "nfs"
end
```


### Faster Vagrant provisioning

For complex application, provisioning your box with the initial “vagrant up” command can take a long time. 
Fortunately, it’s not necessary to do this for every member of your team, on every computer that will be used for development. 
You can use the following command to create a filename.box file, which is the already provisioned box.

```bash
vagrant package --output filename
```

You should store this file somewhere suitable, then include the URL in your Vagrantfile. 
When you next run “vagrant up”, it will download the already provisioned box instead of creating a new one and running the provisioning scripts. 
You can also include file paths (such as on your local network) as the box_url parameter.

```ruby
Vagrant.configure("2") do |config|
    # ...
    config.vm.box = 'filename'
    config.vm.box_url = 'http://your-url.com/filename.box'
end
```
