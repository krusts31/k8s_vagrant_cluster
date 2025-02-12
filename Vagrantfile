Vagrant.configure("2") do |config|
  #config.vm.box = "bento/ubuntu-24.04"
  #config.vm.box_version = "202404.26.0"
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20241217.1"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    controlplane.vm.network "private_network", ip: 10.0.0.10
    master.vm.network "public_network", ip: "192.168.8.181", bridge: "en0: Wi-Fi (AirPort)"

    master.vm.provider "virtualbox" do |vb|
      vb.name = "Master"
      vb.memory = 4096
      vb.cpus = 2
      vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "/Users/admin/VirtualDisks/disk_1.vdi"]
    end
  end

  config.vm.define "worker" do |worker|
    worker.vm.hostname = "worker"
    controlplane.vm.network "private_network", ip: 10.0.0.11
    worker.vm.network "public_network", ip: "192.168.8.182", bridge: "en0: Wi-Fi (AirPort)"
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "WorkerNode"
      vb.memory = 4096
      vb.cpus = 2
      vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "/Users/admin/VirtualDisks/disk_2.vdi"]
    end
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.hostname = "worker2"
    controlplane.vm.network "private_network", ip: 10.0.0.12
    worker2.vm.network "public_network", ip: "192.168.8.183", bridge: "en0: Wi-Fi (AirPort)"
    worker2.vm.provider "virtualbox" do |vb|
      vb.name = "WorkerNode2"
      vb.memory = 4096
      vb.cpus = 2
      vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "/Users/admin/VirtualDisks/disk_3.vdi"]
    end
  end
end
