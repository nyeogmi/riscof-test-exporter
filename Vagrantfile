Vagrant.configure("2") do |config|
    # Use bionic64, a stripped-down Ubuntu install provided by Hashicorp
    config.vm.box = "hashicorp/bionic64"
    config.vm.synced_folder "./", "/project/riscof-test-exporter"
    config.vm.synced_folder "./devices", "/project/devices"
    config.vm.synced_folder "./outbox", "/project/outbox", type: "virtualbox"
    config.vm.provision "shell", inline: "bash /project/riscof-test-exporter/setup.sh" 
    config.vm.provider "virtualbox" do |v| v.memory = 4096 end # gcc needs a lot of memory
end