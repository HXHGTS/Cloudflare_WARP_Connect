# Add-Netflix_Support

为非原生ip的vps添加奈飞支持(需要配合v2ray/xray出口规则修改)

使用脚本安装xray/v2ray后，可用此脚本添加Netflix支持，原生ip请忽略！

双栈实现命令:

```
PostUp = ip -4 rule add from [IP] lookup main; ip -6 rule add from [IPV6] lookup main;
PostDown = ip -4 rule delete from [IP] lookup main; ip -6 rule add from [IPV6] lookup main;
```
