ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|

  config.vagrant.plugins = [ 'vagrant-registration' ]
  config.registration.username = ENV['SUB_USERNAME']
  config.registration.password = ENV['SUB_PASSWORD']

  config.vm.define "ipa" do |ipa|
    ipa.vm.box = "rhel76"
    ipa.vm.hostname = "ipa.example999.com"
    ipa.vm.synced_folder ".", "/vagrant", type: "nfs"
    ipa.vm.network "private_network", ip: "192.168.33.11"
    ipa.vm.provider :libvirt do |libvirt|
      libvirt.memory = 2048
    end
    ipa.vm.provision "shell", inline: <<-SHELL
      #install Redhat IdM (AKA FreeIPA with RedHat-branding)
      yum -y update 
      yum -y install ipa-server ipa-server-dns
      
      #fix /etc/hosts
      sed -i'' '/ipa/d' /etc/hosts
      echo '192.168.33.11	ipa.example999.com ipa' >>/etc/hosts
      ipa-server-install -U -n example999.com -r EXAMPLE999.COM -p password -a password --setup-dns --hostname ipa.example999.com --forwarder 8.8.8.8 --forwarder 8.8.4.4 --mkhomedir

      #Fix ssh-ing with unqualified hostname
      sed -i'' -e '/rdns =/s/false/true/' -e '/dns_canonicalize_hostname /s/false/true/' /etc/krb5.conf
    SHELL
  end

  config.vm.define "rhel76" do |rhel76|
    rhel76.vm.box = "rhel76"
    rhel76.vm.hostname = "rhel76.example999.com"
    rhel76.vm.synced_folder ".", "/vagrant", type: "nfs"
    rhel76.vm.network "private_network", ip: "192.168.33.10"
    rhel76.vm.provider :libvirt do |libvirt|
      libvirt.memory = 2048
    end
    rhel76.vm.provision "shell", inline: <<-SHELL
      yum -y update 
      yum -y group install "Directory Client"
      yum install -y sss\*

      #use ipaserver as resolver
      nmcli con mod eth0 ipv4.ignore-auto-dns true
      nmcli con mod eth0 ipv4.dns 192.168.33.11
      nmcli con up eth0

      #install and configure ipa-client
      yum install -y ipa-client
      ipa-client-install -U -p admin -w password --mkhomedir

      #Fix ssh-ing with unqualified hostname
      sed -i'' -e '/rdns =/s/false/true/' -e '/dns_canonicalize_hostname /s/false/true/' /etc/krb5.conf
    SHELL
  end

end
