#!/bin/bash

TMPSRC=/tmp/systemCheck

printAlign(){
	CNT=0
	while IFS= read -r line;do
		if [ ${CNT} == 0 ];then 
			printf "%s\n" "$line"
		else
			printf "%-32s %s\n" " " "$line"
		fi
		CNT=${CNT}+1
    done < $*
}

MAIN(){
	# make working folder 
	mkdir -p ${TMPSRC}
	
	# Operating System
	OSName=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d"=" -f2 | tr -d '"')
	printf '\033[33m%-30s :\033[0m %s\n' "Operating System" "${OSName}" 
	
	# Check Architecture
	Architecture=$(uname -m)
	printf '\033[33m%-30s :\033[0m %s\n' "Architecture" "${Architecture}"

	# Check Kernel Release
	KRelease=$(uname -r)
	printf '\033[33m%-30s :\033[0m %s\n' "Kernel Release" "${KRelease}"
	
	# Check Hostname
	Hostname=$(hostname -f)
	printf '\033[33m%-30s :\033[0m %s\n' "Hostname" "${Hostname}" 	
	
	# Check Internal IP
	InternalIp=$(hostname -I)
	printf '\033[33m%-30s :\033[0m %s\n' "Internal IP" "${InternalIp}" 

	# Check External IP
	ExternalIp=$(curl -s ipecho.net/plain;echo)
	printf '\033[33m%-30s :\033[0m %s\n' "External IP" "${ExternalIp}"

	# User logins
	who > ${TMPSRC}/userlogin
	printf '\033[33m%-30s :\033[0m %s\n' "Logged in Session" "$(printAlign ${TMPSRC}/userlogin)"
	
	# Load average
	LoadAvg=$(cat /proc/loadavg | awk '{printf "%s,%s,%s",$1,$2,$3}')
	printf '\033[33m%-30s :\033[0m %s\n' "Load Average" "${LoadAvg}"
	
	# Storage
	df -kh > ${TMPSRC}/diskMag
	printf '\033[33m%-30s :\033[0m %s\n' "Storage" "$(printAlign ${TMPSRC}/diskMag)"
	
	# Ram utilisation
	RAMUsage=$(free -m | grep Mem | awk '{printf "Total - %s , Free - %s , Used - %s , Cache - %s",$2,$4,$3,$6!=Null?$6:0}')
	printf '\033[33m%-30s :\033[0m %s\n' "RAM Utilisation" "${RAMUsage}"
	
	# Swap utilisation
	SwapUsage=$(free -m | grep Swap | awk '{printf "Total - %s , Free - %s , Used - %s , Cache - %s ",$2,$4,$3,$6!=Null?$6:0}')
	printf '\033[33m%-30s :\033[0m %s\n' "Swap Utilisation" "${SwapUsage}"
	
	# Inodes
	df -ih > ${TMPSRC}/inodeMag
	printf '\033[33m%-30s :\033[0m %s\n' "Inodes stats" "$(printAlign ${TMPSRC}/inodeMag)"
	
	UpTime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
	printf '\033[33m%-30s :\033[0m %s\n' "Up Since" "${UpTime}"
	
	# Clear working folder
	rm -rf ${TMPSRC}
}

MAIN $*