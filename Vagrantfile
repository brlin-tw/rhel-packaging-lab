# Vagrant configuration file
#
# Copyright 2024 林博仁(Buo-ren, Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0
Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky9"
  #config.vm.box = "generic/rhel9"

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "512"
  end

  config.vm.provision "shell", path: "./lab-assets/deploy-lab-environment.sh"
end
