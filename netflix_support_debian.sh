#!/bin/sh
echo 正在安装wireguard. . .
echo 13.35.162.73 download.copr.fedorainfracloud.org > /etc/hosts
echo 38.145.60.24 dl.fedoraproject.org >> /etc/hosts
apt install dnsutils -y
apt-get install wireguard -y
wget https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /etc/wireguard/wgcf_2.2.3_linux_amd64
cd /etc/wireguard && chmod +x wgcf_2.2.3_linux_amd64
echo 正在注册WARP账号. . .
echo yes | ./wgcf_2.2.3_linux_amd64 register
./wgcf_2.2.3_linux_amd64 generate
echo /etc/wireguard/wgcf-profile.conf | find -v "172.16.0.2/32"  | find -v "0.0.0.0/0" | find -v "engage.cloudflareclient.com" > /etc/wireguard/wgcf.conf
echo Endpoint = 162.159.192.1:2408 >> /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
exit 0
