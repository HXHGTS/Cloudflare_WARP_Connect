# Cloudflare_WARP_Connect

警告⚠:目前此方法已不可用于解锁Netflix!!!

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

