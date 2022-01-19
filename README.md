# Cloudflare_WARP_Connect

警告⚠:目前此方法解锁Netflix需要强制IPV4出口并刷出特定出口ip(美区除外)，配合v2ray/xray出口规则修改，原生ip请忽略！

奈飞检测脚本(基于[lmc999流媒体检测脚本](https://github.com/lmc999/RegionRestrictionCheck)修改而来，适用于本项目出口ip检测):
```
echo 1 | bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/check.sh) -M 4
```

1.脚本运行:

`CentOS7(vps仅提供ipv4网络):`
```
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/netflix_support.sh)
```

`CentOS8(vps仅提供ipv4网络):`
```
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/netflix_support_centos8.sh)
```

`Debian/Ubuntu(vps仅提供ipv4网络):`
```
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/TCPOptimization/master/KernelUpdate_debian10.sh)
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/netflix_support_debian.sh)
```

`CentOS7/8(vps仅提供ipv6网络):`
```
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/netflix_support_ipv6.sh)
```

`Debian/Ubuntu(vps仅提供ipv6网络):`
```
bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/netflix_support_debian_ipv6.sh)
```

2.在`/usr/local/etc/xray`文件夹或`/usr/local/etc/v2ray`中找到配置文件`config.json`并按仓库中[模板格式](https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/config.json)修改

3.应该可以正常使用了

warp关闭:
```
systemctl stop wg-quick@wgcf && systemctl disable wg-quick@wgcf && systemctl status wg-quick@wgcf
```

warp启动:
```
systemctl start wg-quick@wgcf && systemctl enable wg-quick@wgcf && systemctl status wg-quick@wgcf
```

warp重启/切换出口ip:
```
systemctl restart wg-quick@wgcf && echo 1 | bash <(curl -L -s https://raw.githubusercontent.com/HXHGTS/Cloudflare_WARP_Connect/main/check.sh) -M 4
```

建议配合[看门狗](https://github.com/HXHGTS/WARP-WatchDog)食用!


