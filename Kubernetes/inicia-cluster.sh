#!/bin/bash

echo -e "\nCONFIGURANDO CLUSTER KUBERNETES\n"

sudo kubeadm reset && sudo swapoff -a

echo -e "\nIniciando cluster\n"

sudo sysctl net.bridge.bridge-nf-call-iptables=1

#Inicia cluster para plugin de rede Weave
#sudo kubeadm init --apiserver-advertise-address $(hostname -i) | grep 'kubeadm join' > $HOME/.kube/token.sh

#Inicia cluster para plugin de rede Flannel - para permitir trabalhar com NodePort.
sudo kubeadm init --apiserver-advertise-address $(hostname -i) | grep -A1 'kubeadm join' > $HOME/.kube/token.sh

mkdir -p $HOME/.kube

sudo chmod 777 $HOME/.kube/token.sh

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo -e "\nCriando ambiente do cluster\n"

#Criando a rede do cluster pelo plugin Weave
#kubectl create -f net-weave.yaml

kubectl apply -f net-weave.yaml

kubectl apply -f dashboard.yaml

kubectl apply -f metallb.yaml

kubectl apply -f metallb-config.yaml

kubectl apply -f role-kubernetes-admin.yaml

# ./configura-nodes.sh
./cria-token.sh

#echo -e "\nBuscando Token de acesso\n"
#export TOKEN=$(kubectl describe secret tharles-user -n slice-tharles | grep "token:" | awk '{print $2}')

xterm -hold -e kubectl proxy &

#echo -e "\ntoken: $TOKEN \n\n"
