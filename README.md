# Add-Netflix_Support

为非原生ip的vps添加奈飞支持(需要配合v2ray/xray出口规则修改)

使用脚本安装xray/v2ray后，可用此脚本添加Netflix支持，原生ip请忽略！

1.脚本运行:

`CentOS7/8(vps仅提供ipv4网络):`
```
curl https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/netflix_support.sh | sh
```

`Debian/Ubuntu(vps仅提供ipv4网络):`
```
curl https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/netflix_support_debian.sh | sh
```

`CentOS7/8(vps仅提供ipv6网络):`
```
curl https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/netflix_support_ipv6.sh | sh
```

`Debian/Ubuntu(vps仅提供ipv6网络):`
```
curl https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/netflix_support_debian_ipv6.sh | sh
```

2.在`/usr/local/etc/xray`文件夹或`/usr/local/etc/v2ray`中找到配置文件`config.json`并按仓库中[模板格式](https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/config.json)修改

3.应该可以观看Netflix了
