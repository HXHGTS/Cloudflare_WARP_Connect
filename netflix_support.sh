#!/bin/sh
echo 正在安装wireguard. . .
echo 13.35.162.73 download.copr.fedorainfracloud.org > /etc/hosts
echo 38.145.60.24 dl.fedoraproject.org >> /etc/hosts
yum install net-tools.x86_64 -y
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/jdoss-wireguard-epel-7.repo
yum install wireguard-dkms wireguard-tools -y
wget https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /etc/wireguard/wgcf_2.2.3_linux_amd64
cd /etc/wireguard && chmod +x wgcf_2.2.3_linux_amd64
echo 正在注册WARP账号. . .
echo yes | ./wgcf_2.2.3_linux_amd64 register
./wgcf_2.2.3_linux_amd64 generate
cat /etc/wireguard/wgcf-profile.conf | grep -v "engage.cloudflareclient.com" | grep -v "172.16.0.2/32" | grep -v "0.0.0.0/0" > /etc/wireguard/wgcf.conf
echo Endpoint = 162.159.192.1:2408 >> /etc/wireguard/wgcf.conf
echo 安装成功，请修改xray/v2ray配置文件后手动运行！
exit 0

