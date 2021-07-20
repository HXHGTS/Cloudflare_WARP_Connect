#!/bin/sh
echo 正在安装wireguard. . .
echo nameserver 2001:67c:2b0::4 > /etc/resolv.conf
echo nameserver 2001:67c:2b0::6 >> /etc/resolv.conf
echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
apt update
apt install net-tools iproute2 openresolv dnsutils -y
apt install wireguard-tools --no-install-recommends
curl -sSL https://raw.githubusercontent.com/P3TERX/script/master/wireguard-go.sh | sh
wget https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /etc/wireguard/wgcf_2.2.3_linux_amd64
cd /etc/wireguard && chmod +x wgcf_2.2.3_linux_amd64
echo 正在注册WARP账号. . .
echo yes | ./wgcf_2.2.3_linux_amd64 register
./wgcf_2.2.3_linux_amd64 generate
cat /etc/wireguard/wgcf-profile.conf | grep -v "engage.cloudflareclient.com" | grep -v "/128" | grep -v "::/0" > /etc/wireguard/wgcf.conf
echo Endpoint = [2606:4700:d0::a29f:c001]:2408 >> /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
echo 运行成功，请修改xray/v2ray配置文件！
exit 0
