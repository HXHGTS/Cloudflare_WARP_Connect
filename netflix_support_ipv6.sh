#!/bin/sh
echo 正在安装wireguard. . .
echo nameserver 2001:67c:2b0::4 > /etc/resolv.conf
echo nameserver 2001:67c:2b0::6 >> /etc/resolv.conf
echo 2600:9000:2135:f400:4:bbc1:1840:93a1 download.copr.fedorainfracloud.org > /etc/hosts
echo 2001:67c:2b0:db32:0:1:2691:3c17 dl.fedoraproject.org >> /etc/hosts
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
echo Endpoint = [2606:4700:d0::a29f:c001]:2408 >> /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
echo 运行成功，请修改xray/v2ray配置文件！
exit 0
