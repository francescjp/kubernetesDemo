# Start Using Kubernetes

Here are there is a demo from the architecture shown in the training.

### Installation
Setup 2 Ubuntu 18.04 VM (from now on the Box) using the following command:

```
    vagrant up
```

The box contains docker engine, docker compose and docker machine.

### Prepare the master
```
    vagrant@kubernetes-master:~$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
    vagrant@kubernetes-master:~$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    vagrant@kubernetes-master:~$ sudo apt install kubeadm -y
    vagrant@kubernetes-master:~$ sudo swapoff -a
    vagrant@kubernetes-master:~$ sudo hostnamectl set-hostname kubernetes-master

```

### Initialize Kubernetes master Server

Now we are ready to initialize the Kubernetes master node. To do so execute the following linux command on your master node:

```
    vagrant@kubernetes-master:~$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    vagrant@kubernetes-master:~$ mkdir -p $HOME/.kube
    vagrant@kubernetes-master:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    vagrant@kubernetes-master:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Deploy a pod network

Next step is to deploy a pod network. The pod network is used for communication between nodes within the Kubernetes cluster. For this we will use the Flannel pod network:

```
    vagrant@kubernetes-master:~$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Depending on your environment it may take few seconds or a minute to bring the entire flannel network up. Use the kubectl command to confirm that everything is up and ready:

```
    vagrant@kubernetes-master:~$ kubectl get pods --all-namespaces
```

### Join Kubernetes Cluster

All should be now ready for our node(s) to join Kubernetes cluster. Use the kubeadm join command retrieved earlier from the Kubernetes master node initialization output to join your Kubernetes cluster:

```
    vagrant@kubernetes-slave:~$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
    vagrant@kubernetes-slave:~$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    vagrant@kubernetes-slave:~$ sudo apt install kubeadm -y
    vagrant@kubernetes-slave:~$ sudo swapoff -a
    vagrant@kubernetes-slave:~$ sudo hostnamectl set-hostname kubernetes-slave
    vagrant@kubernetes-slave:~$ sudo kubeadm join 10.1.1.9:6443 --token 1522dj.ox2o6in5c1u44sku --discovery-token-unsafe-skip-ca-verification
```

On your Kubernetes master node confirm that the node kubernetes-slave is now part of our Kubernetes cluster:

```
    vagrant@kubernetes-master:~$ kubectl get nodes
```

### Deploying a service on Kubernetes cluster

As a proof of concept we will now deploy a Nginx server into our new Kubernetes cluster. Now, run the following two commands on your master node :

```
    vagrant@kubernetes-master:~$ kubectl run --image=nginx nginx-server --port=80 --env="DOMAIN=cluster"
    vagrant@kubernetes-master:~$ kubectl expose deployment nginx-server --port=80 --name=nginx-http
```

You should now see a new nginx docker container deployed on your slave node:

```
    vagrant@kubernetes-slave:~$ sudo docker ps
```

### Deploy service on Kubernetes Cluster on Ubuntu 18.04
New docker Nginx container is up and running on Kubernetes slave node.
To confirm that our new Nginx service is up and running list all available services on your master node and use the curl command to perform a HTTP request on your CLUSTER IP:
```
    vagrant@kubernetes-master:~$ kubectl get svc
    vagrant@kubernetes-master:~$ curl -I 10.101.230.239
```

### Deploy a custom pod network
Create a pod, it is need to download the example code:
```
    vagrant@kubernetes-master:~$ git clone https://bitbucket.org/itnove/startusingkubernetes.git

    vagrant@kubernetes-master:~$ cd startusingkubernetes

    vagrant@kubernetes-master:~$ kubectl create -f pod-k8s-demo.yml
```

### Create service
```
    vagrant@kubernetes-master:~$ kubectl create -f service-k8s-demo.yml
```

### Create replicas
```
    vagrant@kubernetes-master:~$ kubectl create -f replication-controller-k8s-demo.yml
```

### Get pod info

```
    vagrant@kubernetes-master:~$ kubectl list pod
```

### Delete pod

```
    vagrant@kubernetes-master:~$ kubectl delete pod podname
```

### Get service info

```
    vagrant@kubernetes-master:~$ kubectl list serice
```

### Delete pod

```
    vagrant@kubernetes-master:~$ kubectl delete service servicename
```


### Support

This tutorial is released into the public domain by [ITNove](http://www.itnove.com) under WTFPL.

[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-1.png)](http://www.wtfpl.net/)

This README file was originally written by [Guillem Hernández Sola](https://www.linkedin.com/in/guillemhernandezsola/) and is likewise released into the public domain.

Please contact ITNove for further details.

* ITNOVE 
* Passeig de Gràcia 110, 4rt 2a
* 08008 Barcelona
* T: 93 184 53 44