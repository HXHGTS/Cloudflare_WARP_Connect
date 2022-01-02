#!/bin/bash

Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";

while getopts ":I:M:L:" optname
do
    case "$optname" in
		"I")
        iface="$OPTARG"
		useNIC="--interface $iface"
        ;;
		"M")
        if [[ "$OPTARG" == "4" ]];then
			NetworkType=4
		elif [[ "$OPTARG" == "6" ]];then
			NetworkType=6
		fi	
        ;;
		"L")
        language="e"
        ;;
		":")
        echo "Unknown error while processing options"
		exit 4
        ;;
    esac
    
done

if [ -z "$iface" ];then
	useNIC=""
fi	

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
WOWOW_Cookie=$(curl -s https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/cookies | awk 'NR==3')
TVer_Cookie="Accept: application/json;pk=BCpkADawqM3ZdH8iYjCnmIpuIRqzCn12gVrtpk_qOePK3J9B6h7MuqOw5T_qIqdzpLvuvb_hTvu7hs-7NsvXnPTYKd9Cgw7YiwI9kFfOOCDDEr20WDEYMjGiLptzWouXXdfE996WWM8myP3Z"

CountRunTimes(){
RunTimes=$(curl -s --max-time 10 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fraw.githubusercontent.com%2Flmc999%2FRegionRestrictionCheck%2Fmain%2Fcheck.sh&count_bg=%2379C83D&title_bg=%2300B1FF&icon=&icon_color=%23E7E7E7&title=script+run+times&edge_flat=false" > ~/couting.txt)
TodayRunTimes=$(cat ~/couting.txt | tail -3 | head -n 1 | awk '{print $5}')
TotalRunTimes=$(cat ~/couting.txt | tail -3 | head -n 1 | awk '{print $7}')
rm -rf ~/couting.txt
}
CountRunTimes

checkos(){
	ifTermux=$(echo $PWD | grep termux)
	ifMacOS=$(uname -a | grep Darwin)
	if [ -n "$ifTermux" ];then
		os_version=Termux
	elif [ -n "$ifMacOS" ];then
		os_version=MacOS	
	else	
		os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
	fi
	
	if [[ "$os_version" == "2004" ]] || [[ "$os_version" == "10" ]] || [[ "$os_version" == "11" ]];then
		ssll="-k --ciphers DEFAULT@SECLEVEL=1"
	fi
}
checkos	

checkCPU(){
	CPUArch=$(uname -m)
	if [[ "$CPUArch" == "aarch64" ]];then
		arch=_arm64
	elif [[ "$CPUArch" == "i686" ]];then
		arch=_i686
	elif [[ "$CPUArch" == "arm" ]];then
		arch=_arm
	elif [[ "$CPUArch" == "x86_64" ]] && [ -n "$ifMacOS" ];then
		arch=_darwin	
	fi
}	
checkCPU

check_dependencies(){

	os_detail=$(cat /etc/os-release 2> /dev/null)
	if_debian=$(echo $os_detail | grep 'ebian')
	if_redhat=$(echo $os_detail | grep 'rhel')
	if [ -n "$if_debian" ];then
		InstallMethod="apt"
	elif [ -n "$if_redhat" ] && [[ "$os_version" -gt 7 ]];then
		InstallMethod="dnf"
	elif [ -n "$if_redhat" ] && [[ "$os_version" -lt 8 ]];then
		InstallMethod="yum"
	elif [[ "$os_version" == "Termux" ]];then
		InstallMethod="pkg"
	elif [[ "$os_version" == "MacOS" ]];then
		InstallMethod="brew"	
	fi
	
	python -V > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			python3 -V > /dev/null 2>&1
			if [[ "$?" -eq "0" ]];then
				python3_patch=$(which python3)
				ln -s $python3_patch /usr/bin/python > /dev/null 2>&1
			else
				if [ -n "$if_debian" ];then
					echo -e "${Font_Green}Installing python${Font_Suffix}" 
					$InstallMethod update  > /dev/null 2>&1
					$InstallMethod install python -y  > /dev/null 2>&1
				elif [ -n "$if_redhat" ];then
					echo -e "${Font_Green}Installing python${Font_Suffix}"
					if [[ "$os_version" -gt 7 ]];then
						$InstallMethod update  > /dev/null 2>&1
						$InstallMethod install python3 -y > /dev/null 2>&1
						python3_patch=$(which python3)
						ln -s $python3_patch /usr/bin/python
					else
						$InstallMethod update  > /dev/null 2>&1
						$InstallMethod install python -y > /dev/null 2>&1
					fi	
					
				elif [[ "$os_version" == "Termux" ]];then
					echo -e "${Font_Green}Installing python${Font_Suffix}"
					$InstallMethod update -y > /dev/null 2>&1
					$InstallMethod install python -y > /dev/null 2>&1
					
				elif [[ "$os_version" == "MacOS" ]];then
					echo -e "${Font_Green}Installing python${Font_Suffix}"
					$InstallMethod install python	
					
				fi
			fi	
		fi
	
	dig -v  > /dev/null 2>&1
	if [[ "$?" -ne "0" ]];then
		if [[ "$InstallMethod" == "apt" ]];then
			echo -e "${Font_Green}Installing dnsutils${Font_Suffix}"
			$InstallMethod update  > /dev/null 2>&1
			$InstallMethod install dnsutils -y > /dev/null 2>&1
		elif [[ "$InstallMethod" == "yum" ]];then
			echo -e "${Font_Green}Installing bind-utils${Font_Suffix}"
			$InstallMethod update  > /dev/null 2>&1
			$InstallMethod install bind-utils -y > /dev/null 2>&1
		elif [[ "$InstallMethod" == "pkg" ]];then
			echo -e "${Font_Green}Installing dnsutils${Font_Suffix}"
			$InstallMethod update -y > /dev/null 2>&1
			$InstallMethod install dnsutils -y > /dev/null 2>&1	
		elif [[ "$InstallMethod" == "brew" ]];then
			echo -e "${Font_Green}Installing bind${Font_Suffix}"
			$InstallMethod install bind	
		fi
	fi	
	
	if [[ "$os_version" == "MacOS" ]];then
		md5sum /dev/null > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			echo -e "${Font_Green}Installing md5sha1sum${Font_Suffix}"
			$InstallMethod install md5sha1sum
		fi
	fi		
}		
check_dependencies

local_ipv4=$(curl $useNIC --interface 172.16.0.2 -4 -s --max-time 10 api64.ipify.org)
local_ipv6=$(curl $useNIC -6 -s --max-time 20 api64.ipify.org)
local_isp4=$(curl $useNIC --interface 172.16.0.2 -4 -s --max-time 10 https://api.ip.sb/geoip/${local_ipv4} | cut -f1 -d"," | cut -f4 -d '"')
local_isp6=$(curl $useNIC -6 -s --max-time 10 https://api.ip.sb/geoip/${local_ipv6} | cut -f1 -d"," | cut -f4 -d '"')
		

ShowRegion(){
	echo -e "${Font_Yellow} ---${1}---${Font_Suffix}"
}	

function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix:\t\t\t\t->\c";
    local result1=$(curl $useNIC -${1} --interface 172.16.0.2 --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
	
    if [[ "$result1" == "404" ]];then
        echo 0 > /root/unlock.log
        return;
		
	elif  [[ "$result1" == "403" ]];then
        echo 0 > /root/unlock.log
        return;
		
	elif [[ "$result1" == "200" ]];then
		local region=`tr [:lower:] [:upper:] <<< $(curl $useNIC -${1} --interface 172.16.0.2 --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
		if [[ ! -n "$region" ]];then
			region="US";
		fi
		echo 1 > /root/unlock.log
		return;
	elif  [[ "$result1" == "000" ]];then
		echo 0 > /root/unlock.log
        return;
    fi   
}

function Global_UnlockTest() {		
	MediaUnlockTest_Netflix ${1};
}

function CheckV4() {
	if [[ "$language" == "e" ]];then
		if [[ "$NetworkType" == "6" ]];then
			isv4=0
			echo -e "${Font_SkyBlue}User Choose to Test Only IPv6 Results, Skipping IPv4 Testing...${Font_Suffix}"
			
		else
			echo -e " ${Font_SkyBlue}** Checking Results Under IPv4${Font_Suffix} "
			echo "--------------------------------"
			echo -e " ${Font_SkyBlue}** Your IPV4 Address: ${local_ipv4}${Font_Suffix} "
			echo -e " ${Font_SkyBlue}** Your Network Provider: ${local_isp4}${Font_Suffix} "
			check4=`ping 1.1.1.1 -c 1 2>&1`;
			if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
				isv4=1
			else
				echo -e "${Font_SkyBlue}No IPv4 Connectivity Found, Abort IPv4 Testing...${Font_Suffix}"
				isv4=0
			fi

			echo ""
		fi	
	else
		if [[ "$NetworkType" == "6" ]];then
			isv4=0
			echo -e "${Font_SkyBlue}用户选择只检测IPv6结果，跳过IPv4检测...${Font_Suffix}"
			
		else
			echo -e " ${Font_SkyBlue}** 正在测试IPv4解锁情况${Font_Suffix} "
			echo "--------------------------------"
			echo -e " ${Font_SkyBlue}** 您的ipv4地址为: ${local_ipv4}${Font_Suffix} "
			echo -e " ${Font_SkyBlue}** 您的网络为: ${local_isp4}${Font_Suffix} "
			check4=`ping 1.1.1.1 -c 1 2>&1`;
			if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
				isv4=1
			else
				echo -e "${Font_SkyBlue}当前主机不支持IPv4,跳过...${Font_Suffix}"
				isv4=0
			fi

			echo ""
		fi	
	fi	
}

function CheckV6() {
	if [[ "$language" == "e" ]];then
		if [[ "$NetworkType" == "4" ]];then
			isv6=0
			echo -e "${Font_SkyBlue}User Choose to Test Only IPv4 Results, Skipping IPv6 Testing...${Font_Suffix}"
		else	
			check6_1=$(curl $useNIC -fsL --write-out %{http_code} --output /dev/null --max-time 10 ipv6.google.com)
			check6_2=$(curl $useNIC -fsL --write-out %{http_code} --output /dev/null --max-time 10 ipv6.ip.sb)
			if [[ "$check6_1" -ne "000" ]] || [[ "$check6_2" -ne "000" ]];then
				echo ""
				echo ""
				echo -e " ${Font_SkyBlue}** Checking Results Under IPv6${Font_Suffix} "
				echo "--------------------------------"
				echo -e " ${Font_SkyBlue}** Your IPV6 Address: ${local_ipv6}${Font_Suffix} "
				echo -e " ${Font_SkyBlue}** Your Network Provider: ${local_isp6}${Font_Suffix} "
				isv6=1
			else
				echo -e "${Font_SkyBlue}No IPv6 Connectivity Found, Abort IPv6 Testing...${Font_Suffix}"
				isv6=0
			fi
			echo -e "";
		fi	

	else
	
		if [[ "$NetworkType" == "4" ]];then
			isv6=0
			echo -e "${Font_SkyBlue}用户选择只检测IPv4结果，跳过IPv6检测...${Font_Suffix}"
		else	
			check6_1=$(curl $useNIC -fsL --write-out %{http_code} --output /dev/null --max-time 10 ipv6.google.com)
			check6_2=$(curl $useNIC -fsL --write-out %{http_code} --output /dev/null --max-time 10 ipv6.ip.sb)
			if [[ "$check6_1" -ne "000" ]] || [[ "$check6_2" -ne "000" ]];then
				echo ""
				echo ""
				echo -e " ${Font_SkyBlue}** 正在测试IPv6解锁情况${Font_Suffix} "
				echo "--------------------------------"
			                echo -e " ${Font_SkyBlue}** 您的ipv4地址为: ${local_ipv6}${Font_Suffix} "
				echo -e " ${Font_SkyBlue}** 您的网络为: ${local_isp6}${Font_Suffix} "
				isv6=1
			else
				echo -e "${Font_SkyBlue}当前主机不支持IPv6,跳过...${Font_Suffix}"
				isv6=0
			fi
			echo -e "";
		fi	
	fi	
}

function Goodbye(){
	if [[ "$language" == "e" ]];then
		echo -e "Test finished!";
		echo ""
	else
		echo -e "测试完成!";
		echo ""
	fi
}

clear;

function ScriptTitle(){
	if [[ "$language" == "e" ]];then
		echo -e "【Netflix Test】";
		echo ""
		echo -e " ** Test Starts At: $(date)";
		echo ""
	else
		echo -e "【奈飞测试】";
		echo ""
		echo -e " ** 测试时间: $(date)";
		echo ""
	fi
}
ScriptTitle

function Start(){
	if [[ "$language" == "e" ]];then
		echo -e "${Font_Blue}Please Select Test Region or Press ENTER to Test All Regions${Font_Suffix}"
		echo -e "${Font_SkyBlue}Input Number【1】：【 Netflix 】${Font_Suffix}"
		read -p "Please Input the Correct Number or Press ENTER:" num
	else
		echo -e "${Font_Blue}请选择检测项目，直接按回车将进行全区域检测${Font_Suffix}"
		echo -e "${Font_SkyBlue}输入数字【1】：【 奈飞平台 】检测${Font_Suffix}"
		read -p "请输入正确数字或直接按回车:" num
	fi	
}
Start

function RunScript(){
	if [[ -n "${num}" ]]; then
		if [[ "$num" -eq 1 ]]; then
			clear
			ScriptTitle
			CheckV4
			if [[ "$isv4" -eq 1 ]];then
				Global_UnlockTest 4
			fi
			CheckV6
			if 	[[ "$isv6" -eq 1 ]];then
				Global_UnlockTest 6
			fi	
			Goodbye
			
		else
			return
		fi
	else
		clear
		ScriptTitle
		CheckV4
		if [[ "$isv4" -eq 1 ]];then
			Global_UnlockTest 4
		fi	
		CheckV6
		if [[ "$isv6" -eq 1 ]];then
			Global_UnlockTest 6
		fi
		Goodbye	
	fi
}

RunScript
