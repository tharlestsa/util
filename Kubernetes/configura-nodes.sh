#!/bin/bash

export K8S_JOIN=$(cat $HOME/.kube/token.sh | sed 's/^ *//')
#O Código a seguir procurar os nodes da rede e configurar o kubernetes em cada Workernode.
echo -e "\nBuscando nodes...\n"
gateway=$( echo $(route -n | grep 'wlp3s0' | grep '192.168.') | awk '{print $9}')
#gateway=$( route -n | grep 'U[ \t]' | awk '{print $1}' | grep '192.')

in_array() {
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}

declare -a ipWorkerNodes=()
nodes=$(sudo nmap -sP  $gateway/24 | grep -A1 MAC | sed 'N;s/--//' | awk 'NF>0' | awk '/Nmap scan report/{ val=$NF; next } /MAC Address:/{ sub(/.*Address: /,""); sub(/ .*/,""); print val"@"$0 }' | awk 'NR>1' | sed 's/[()]//g')

nodes=$(sudo nmap -sP  $gateway/24 | grep -A1 MAC | sed 'N;s/--//' | awk 'NF>0' | awk '/Nmap scan report/{ val=$NF; next } /MAC Address:/{ sub(/.*Address: /,""); sub(/ .*/,""); print val"@"$0 }' | awk 'NR>1' | sed 's/[()]//g')

#declare -a macsWorkerNodes=("74:2F:68:BA:8F:92 00:40:A7:1A:AF:6C")

declare -a macsWorkerNodes=("c8:9c:dc:16:43:72 08:00:27:8e:10:9b")

for no in $nodes; do
    ip="$(echo $no | sed 's/@/ /g' | awk '{print $1}')"
    mac="$(echo $no | sed 's/@/ /g' | awk '{print $2}')"

    while :
    do
      case $mac in
	    C8:9C:DC:16:43:72)
		    export IP_GEO=$(echo $ip)
		    break
		    ;;
	    00:40:A7:1A:AF:6C)
		    export IP_NODE=$(echo $ip)
		    break
		    ;;
	    *)
		    break
		    ;;
	   esac
    done

    in_array macsWorkerNodes $mac && ipWorkerNodes+=("$ip")  || printf ""
done

echo -e "\nWorker-Nodes IPs: "
printf '%s\n' "${ipWorkerNodes[@]}"
echo -e "\n"
# ATENÇÃO: Se o ssh não estiver logando talvez seja por causa da necessidade de confirmação de um novo IP.
# nesse caso é necessário modificacar o arquivo /etc/ssh/ssh_config alterando o atributo StrictHostKeyChecking ask para StrictHostKeyChecking no
# em seguida executar o comando /etc/init.d/ssh restart


for ip in "${ipWorkerNodes[@]}"
do
    while :
    do
      case $ip in
	    $IP_THARLES)
		    export SENHA=$(echo "224365")
		    break
		    ;;
	    $IP_K8S)
		    export SENHA=$(echo "123")
		    break
		    ;;
	    *)
		    export SENHA=$(echo "123")
		    break
		    ;;
	   esac
    done

    sshpass -p $SENHA ssh -o StrictHostKeyChecking=no root@$ip "echo -e '\nCONFIGURANDO' && hostname && echo && kubeadm reset && swapoff -a && sysctl net.bridge.bridge-nf-call-iptables=1 && $K8S_JOIN && echo";
done
