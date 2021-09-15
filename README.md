# Cloudflare_WARP_Connect

目前此方法解锁Netflix需要强制IPV4出口，请结合v2ray/xray的config.json文件模板修改分流!!!

需要配合v2ray/xray出口规则修改，原生ip请忽略！

以下配置添加在`/etc/wireguard/wgcf.conf`中

warp双栈实现命令(主机仅存在ipv4):
```
PostUp = ip -4 rule add from [IP] lookup main
PostDown = ip -4 rule delete from [IP] lookup main
```
warp双栈实现命令(主机仅存在ipv6):
```
PostUp = ip -6 rule add from [IPV6] lookup main
PostDown = ip -6 rule add from [IPV6] lookup main
```
warp双栈实现命令(主机存在ipv4+ipv6):
```
PostUp = ip -4 rule add from [IP] lookup main; ip -6 rule add from [IPV6] lookup main
PostDown = ip -4 rule delete from [IP] lookup main; ip -6 rule add from [IPV6] lookup main
```
warp关闭:
`systemctl stop wg-quick@wgcf && systemctl disable wg-quick@wgcf`

warp启动:
`systemctl start wg-quick@wgcf && systemctl enable wg-quick@wgcf`
