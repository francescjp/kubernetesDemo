Vagrant.configure(2) do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.define "k8smaster" do |k8smaster|
    k8smaster.vm.box = "bento/ubuntu-16.04"
    k8smaster.vm.hostname = "k8s"
    k8smaster.vm.network "private_network", ip: "10.0.18.99"
    k8smaster.vm.network "forwarded_port", guest: 2379, host: 2379
    k8smaster.vm.network "forwarded_port", guest: 6443, host: 6443
    k8smaster.vm.network "forwarded_port", guest: 3000, host: 3000
    k8smaster.vm.network "forwarded_port", guest: 8080, host: 8080
    k8smaster.vm.network "forwarded_port", guest: 8081, host: 8081
    k8smaster.vm.network "forwarded_port", guest: 8001, host: 8001
    for i in 30000..32767
      k8smaster.vm.network :forwarded_port, guest: i, host: i
    end
    k8smaster.vm.provision "docker"
    k8smaster.vm.provision :shell, :path => "k8s.sh"
  end
end
