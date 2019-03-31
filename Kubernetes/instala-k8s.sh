#!/bin/bash

apt update

apt install -y curl 

echo -e "\n Instalando o Docker\n "
curl -fsSL https://get.docker.com  | bash

echo -e "\n Instalando o dependências do kubernetes\n "

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg  | apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt update

echo -e "\n Instalando o kubernetes\n "

apt-get install -y kubelet kubeadm kubectl
    
echo -e "\n Configurando integração do Docker com o kubernetes\n "
sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload

systemctl enable kubelet

systemctl restart kubelet
