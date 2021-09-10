#!/bin/bash
# random cloudflare anycast ip
#使用说明：加在openwrt上系统--计划任务里添加定时运行，如0 9 * * * bash /root/dns/cf-openwrt.sh
#9点0分运行一次。路由上的爬墙软件节点IP全部换成路由IP，如192.168.1.1:8443，端口全部8443
#在openwrt系统--启动项里exit 0前添加bash /root/dns/cf-openwrt.sh解决软路由重启后失效的问题。
#使用前请更换自己的推送token


localport=8443
remoteport=443

declare -i bandwidth
declare -i speed
pushplus=自己的token
ServerChan=自己的token
ServerChanTurbo=自己的token
Telegrambot=自己的token
bandwidth=100
bash /root/dns/cf-openwrt.sh
		iptables -t nat -D OUTPUT $(iptables -t nat -nL OUTPUT --line-number | grep $localport | awk '{print $1}')
		iptables -t nat -A OUTPUT -p tcp --dport $localport -j DNAT --to-destination $anycast:$remoteport
		echo $(date +'%Y-%m-%d %H:%M:%S') IP指向 $anycast>>/usr/dns/cfnat.txt
                     
		curl -s -o /dev/null --data "token=$pushplus&title=$anycast更新成功！&content= 优选IP $anycast 满足 $bandwidth Mbps带宽需求<br>公网IP $publicip<br/>自治域 AS$asn<br>经纬度 $longitude,$latitude<br>META城市 $city<br>实测带宽 $realbandwidth Mbps<br>峰值速度 $max kB/s<br>数据中心 $colo<br>总计用时 $((end_seconds-start_seconds)) 秒<br>&template=html" http://www.pushplus.plus/send #微信推送最新查找的IP-pushplus推送加
		
		curl -s -o /dev/null --data "text=$anycast更新成功！&desp=$(date +'%Y-%m-%d %H:%M:%S') %0D%0A%0D%0A---%0D%0A%0D%0A * 优选IP $anycast 满足 $bandwidth Mbps带宽需求 %0D%0A * 公网IP $publicip%0D%0A * 自治域 AS$asn %0D%0A * 经纬度 $longitude,$latitude %0D%0A * META城市 $city %0D%0A * 实测带宽 $realbandwidth Mbps %0D%0A * 峰值速度 $max kB/s %0D%0A * 数据中心 $colo %0D%0A * 总计用时 $((end_seconds-start_seconds)) 秒" https://sc.ftqq.com/$ServerChan.send #微信推送最新查找的IP-Server酱

#		curl -s -o /dev/null --data "title=$anycast更新成功！&desp=$(date +'%Y-%m-%d %H:%M:%S') %0D%0A%0D%0A---%0D%0A%0D%0A * 优选IP $anycast 满足 $bandwidth Mbps带宽需求 %0D%0A * 公网IP $publicip%0D%0A * 自治域 AS$asn %0D%0A * 经纬度 $longitude,$latitude %0D%0A * META城市 $city %0D%0A * 实测带宽 $realbandwidth Mbps %0D%0A * 峰值速度 $max kB/s %0D%0A * 数据中心 $colo %0D%0A * 总计用时 $((end_seconds-start_seconds)) 秒"  https://sctapi.ftqq.com/$ServerChanTurbo.send #微信推送最新查找的IP-Server酱·Turbo版

		curl -s -o /dev/null --data "&text=*$anycast更新成功！* %0D%0A$(date +'%Y\-%m\-%d %H:%M:%S')%0D%0A----------------------------------%0D%0A·优选IP $anycast 满足 $bandwidth Mbps带宽需求 %0D%0A·公网IP $publicip%0D%0A·自治域 AS$asn %0D%0A·经纬度 $longitude,$latitude %0D%0A·META城市 $city %0D%0A·实测带宽 $realbandwidth Mbps %0D%0A·峰值速度 $max kB/s %0D%0A·数据中心 $colo %0D%0A----------------------------------&parse_mode=Markdown" https://pushbot.pupilcc.com/sendMessage/$Telegrambot #Telegram推送最新查找的IP- @notification_me_bot
