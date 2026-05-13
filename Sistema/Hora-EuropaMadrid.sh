#!/bin/sh

uci set system.@system[0].zonename='Europe/Madrid'
uci set system.@system[0].timezone='CET-1CEST,M3.5.0/2,M10.5.0/3'
uci commit system
/etc/init.d/system reload
/etc/init.d/sysntpd restart
ntpd -q -p 0.openwrt.pool.ntp.org
date
