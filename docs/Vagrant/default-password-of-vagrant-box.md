## Default username and password of Vagrant box

Path, e.g.: C:\HOME\.vagrant.d\boxes\ubuntu-VAGRANTSLASH-xenial64\20170802.0.0\virtualbox\Vagrantfile

```text
# Front load the includes
include_vagrantfile = File.expand_path("../include/_Vagrantfile", __FILE__)
load include_vagrantfile if File.exist?(include_vagrantfile)

Vagrant.configure("2") do |config|
  config.vm.base_mac = "02D92ED994C0"
  config.ssh.username = "ubuntu"
  config.ssh.password = "08ffd37595c75cce3cf5833c"

  config.vm.provider "virtualbox" do |vb|
     vb.customize [ "modifyvm", :id, "--uart1", "0x3F8", "4" ]
     vb.customize [ "modifyvm", :id, "--uartmode1", "file", File.join(Dir.pwd, "ubuntu-xenial-16.04-cloudimg-console.log") ]
  end
end
```
