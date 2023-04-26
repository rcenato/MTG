#!/bin/bash

#nmap_list.sh

#TRANSLATE ALL TO ENGLISH

helpFunction()
{
   echo ""
   echo "Usage: $0 -e parameterA -t parameterB -f parameterC"
   echo -e "\t-e Numero de Execuções Concorrentes"
   echo -e "\t-t Endereço IP Target"
   echo -e "\t-f Nome do arquivo (Filename) dos NMAPs"
   exit 1 # Exit script after printing help
}

while getopts e:t:f: flag
do
    case "${flag}" in
        e) con_loop=${OPTARG};; #Numero de Execuções Concorrentes
        t) IP=${OPTARG};;       #Endereço IP Target
        f) filename=${OPTARG};; #Nome do arquivo (Filename) dos NMAPs
    esac
done
# Print helpFunction in case parameters are empty
if [ -z "$con_loop" ] || [ -z "$IP" ] || [ -z "$filename" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi


#Variável NET obtida a partir do IP da vitima (rede /24)
export NET="${IP%.*}".0/24""
export IP=$IP

echo "Username: "
 whoami
echo "My IP: "
ifconfig eth0 | grep 'inet ' | cut -c 14-28
echo "Started on: "
 date
echo "Current folder of the script:"
 pwd
echo "Victim IP $IP"

#VM interface
interface="eth0"

#Portscan Target IP
#IP="192.168.15.36"

#IP List
LIST="192.168.15.36"

#Target Subnet
#NET="192.168.15.0/24"


#Fake IPs - for decoy (-D) and spoof (-S)
IPL1="192.168.15.129"
IPL2="192.168.15.130"
IPL3="192.168.15.131"

#Fake MAC
MACL="00:0c:29:87:1f:01"

#IP Zombie - for Idle Scan (-sI)
IPZ="192.168.15.90"

#Script data
echo "IPs (fakes): $IPL1, $IPL2, $IPL3"
echo "Target Subnet: $NET"

nmaplist=$(cat nmap_list.txt)
printf '%s\n' "$nmaplist"
echo "inicio"
echo ",$IP,"


# --- End Definitions Section ---
# check if we are being sourced by another script or shell
[[ "${#BASH_SOURCE[@]}" -gt "1" ]] && { return 0; }

echo "Alternativa 1: Usar Source para chamar outro script .sh, com passagem de parametro"
for n in $(seq $con_loop)
do
    source nmap_list.sh $IP $NET
done
echo "Feita leitura"
echo ""
echo "Alternativa 2: readfile from .txt, chamar função com eval"

while IFS= read -r line
do
    echo "entrou $line"
    echo $line
    eval $line
done <<< $nmaplist

echo "Feito"
echo ""
echo "Alternativa 3: Ler as linhas do arquivo .txt para um array e executar a partir deste script"
declare -a array
declare -i i=0

for x in $(seq $con_loop)
do
    while IFS= read -r line;
    do
    	echo $line
    	eval $line
    	array[i]=$line
    	echo $$
    	echo ${array[i]}
    	i=$i+1
    	eval ${array[i]}
    done < $filename
done
