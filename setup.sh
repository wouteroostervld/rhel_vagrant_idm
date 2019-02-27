#!/usr/bin/env bash
sudo mkdir -p home/vagrant/.ssh
sudo chown root:root home
sudo chmod u=rwX,g=rX,o=rX home
sudo chown 9999:9999 -R home/vagrant
sudo chmod u=rwX,g=rX,o=rX home/vagrant
sudo chmod u=rwX,g=rX,o= home/vagrant/.ssh
sudo cat vagrant.pub | sudo tee -a home/vagrant/.ssh/authorized_keys >/dev/null
sudo chown 9999:9999 home/vagrant/.ssh/authorized_keys 
sudo chmod u=rwX,g=rX,o= home/vagrant/.ssh/authorized_keys
