# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

$COMMANDS = <<-'BLOCK'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install vim git snap sshpass ansible dos2unix docker-ce docker-ce-cli containerd.io default-jre openssl -y
apt install -y ca-certificates curl gnupg lsb-release
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo gpasswd -a vagrant docker && sudo systemctl restart docker
BLOCK
        

Vagrant.configure(2) do |config|

  NodeCount = 1

  (1..NodeCount).each do |i|
    config.vm.define "elk-server" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "elk.example.com"
	    node.vm.network :forwarded_port, guest: 5601,host: 80
      node.vm.network :forwarded_port, guest: 8080,host: 8080
      node.vm.network :forwarded_port, guest: 443,host: 443
	    node.vm.provision "shell",privileged: true, inline: $COMMANDS
      node.vm.network "private_network", ip: "10.10.100.20#{i}"
      node.vm.provider "virtualbox" do |v|
        v.name = "elk-server"
        v.memory = 6144
        v.cpus = 2
      end
    end
  end
