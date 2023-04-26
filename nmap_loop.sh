#!/bin/bash
#nmap_list.sh

#Malicious Traffic Generator
#author: Rafael Cenato
#github.com/rcenato/MTG.git
#INFO:
#Throuput generated per execution:
#Group 1(nmap_list1.txt): $X=1 $t1=4
#Group 2(nmap_list2.txt): $Y $t2
#Group 3(nmap_list3.txt): $Z $t3



helpFunction()
{
   echo ""
   echo "Usage: $0 -e parameterA -t parameterB -f parameterC"
   echo -e "\t-e Desired traffic throughput"
   echo -e "\t-t Target IP"
   echo -e "\t-f Filename of NMAP list"
   exit 1 # Exit script after printing help
}

while getopts e:t:f: flag
do
    case "${flag}" in
        e) traffic=${OPTARG};;  #Desired Traffic Volume (throughput)
        t) IP=${OPTARG};;       #Target address IP
        f) filename=${OPTARG};; #Filename of the nmap list
    esac
done
# Print helpFunction in case parameters are empty
if [ -z "$traffic" ] || [ -z "$IP" ] || [ -z "$filename" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi


#Get the NET variable from IP netmask /24
export NET="${IP%.*}".0/24""
export $IP

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

nmaplist=$(cat /home/kali/ABTRAP/nmap_list.txt)
printf '%s\n' "$nmaplist"

#CoreLoop variables:
X="1"
t1="4"
echo "$traffic"   
# --- End Definitions Section ---    
# check if we are being sourced by another script or shell
[[ "${#BASH_SOURCE[@]}" -gt "1" ]] && { return 0; }

#Core Loop function:
core_loop(){
n=$1
echo "start core_loop $n times"
	for x in $(seq $n)
	do
		while IFS= read -r line
		do
    			echo "[core_loop]Entered $line"
    			eval $line&
		done <<< $nmaplist
		echo "sleep for $t1 seconds"
		sleep $t1
		echo "sleep done"
	done
echo "Done core_loop"
}

# --- Start Decision Section ---
if [ $traffic -ge $X ]
then
	echo "entrou"
	exec=$((traffic / X))
	echo $exec
	core_loop $exec
else
	echo "else"
fi
