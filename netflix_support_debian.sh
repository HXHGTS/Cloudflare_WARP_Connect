#!/bin/sh
set WGCF_VERSION=2.2.18
echo 正在安装wireguard. . .
apt install lsb-release -y
echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
apt update
cp -f /etc/resolv.conf /etc/resolv.conf.backup
apt install iproute2 dnsutils resolvconf -y
cp -f /etc/resolv.conf.backup /etc/resolv.conf && rm -rf /etc/resolv.conf.backup
apt install -y linux-headers-$(uname -r)
apt-get install -y wireguard
apt-get install -y wireguard-tools --no-install-recommends
wget https://github.com/ViRb3/wgcf/releases/download/v${WGCF_VERSION}/wgcf_${WGCF_VERSION}_linux_amd64 -O /etc/wireguard/wgcf_${WGCF_VERSION}_linux_amd64
cd /etc/wireguard && chmod +x wgcf_${WGCF_VERSION}_linux_amd64
echo 正在注册WARP账号. . .
echo yes | ./wgcf_${WGCF_VERSION}_linux_amd64 register
./wgcf_${WGCF_VERSION}_linux_amd64 generate
echo [Interface] > /etc/wireguard/wgcf.conf
cat /etc/wireguard/wgcf-profile.conf | grep "PrivateKey" >> /etc/wireguard/wgcf.conf
echo Address = 172.16.0.2/32 >> /etc/wireguard/wgcf.conf
echo DNS = 1.1.1.1, 1.0.0.1 >> /etc/wireguard/wgcf.conf
echo MTU = 1280 >> /etc/wireguard/wgcf.conf
echo Table = off >> /etc/wireguard/wgcf.conf
echo PostUP = ip -4 rule add from 172.16.0.2 lookup 51820 >> /etc/wireguard/wgcf.conf
echo PostUP = ip -4 route add default dev wgcf table 51820 >> /etc/wireguard/wgcf.conf
echo PostUP = ip -4 rule add table main suppress_prefixlength 0 >> /etc/wireguard/wgcf.conf
echo PostDown = ip -4 rule delete from 172.16.0.2/32 lookup 51820 >> /etc/wireguard/wgcf.conf
echo PostDown = ip -4 rule delete table main suppress_prefixlength 0 >> /etc/wireguard/wgcf.conf
echo >> /etc/wireguard/wgcf.conf
echo [Peer] >> /etc/wireguard/wgcf.conf
echo AllowedIPs = 0.0.0.0/0 >> /etc/wireguard/wgcf.conf
cat /etc/wireguard/wgcf-profile.conf | grep "PublicKey" >> /etc/wireguard/wgcf.conf
echo Endpoint = 162.159.192.1:2408 >> /etc/wireguard/wgcf.conf
systemctl start wg-quick@wgcf && systemctl enable wg-quick@wgcf
echo 安装成功，请修改xray/v2ray配置文件后手动运行！
echo 出口ip:
echo -------------------------
curl ifconfig.me/ip --interface 172.16.0.2
echo
echo -------------------------
exit 0
