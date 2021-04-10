# Add-Netflix_Support
未非原生ip的vps添加奈飞支持(需要配合v2ray/xray出口规则修改)

使用脚本安装xray/v2ray后，可用此脚本添加Netflix支持，原生ip请忽略！

1.脚本运行:
```
curl https://raw.githubusercontent.com/HXHGTS/Add-Netflix_Support/main/netflix_support.sh | sh
```
2.执行完成请在/etc/wireguard/wgcf-profile.conf文件中删除`0.0.0.0/0`一行，并将`engage.cloudflareclient.com`替换为`162.159.192.1`

3.在/usr/local/etc/xray文件夹或/usr/local/etc/v2ray中找到配置文件config.json并按仓库中模板格式修改

4.运行wg`wg-quick up wgcf-profile`启动隧道，应该可以观看Netflix了
