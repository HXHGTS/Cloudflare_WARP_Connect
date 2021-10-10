#!/bin/sh
echo 正在升级内核. . .
apt-get update
apt-get upgrade
apt-get dist-upgrade
echo 重启. . .
reboot
