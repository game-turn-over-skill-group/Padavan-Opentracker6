#!/bin/sh
#查找opentracker6安装路径;如果退出状态不为0(未安装),则开始安装更新;安装后写入txt判断内容:是否安装成功。
which opentracker6
if [ $? -ne 0 ]; then
	logger -t "开始更新opentracker6"
	opkg update && opkg install opentracker6 | tee opt6_log.txt
	if [ -n "$(grep "Configuring opentracker" opt6_log.txt)" ]; then
		logger -t "opentracker6安装成功"
		else
			logger -t "opentracker6安装失败"
			exit 1
	fi

fi

#我睡5秒觉 没毛病吧？
#logger -t "正在启动...opentracker6"
#sleep 5

#查找opentracker6安装路径;如果返回不等于0,则启动;检测进程连接是否为0,不等于0则启动成功,反之失败。
which opentracker6
if [ $? -eq 0 ]; then
	result=$(netstat -apn|grep opentracker | wc -l)
	if [ $result = "0" ]; then
		#ipv6监听tcp:233、tcp:2710+6969
		opentracker6 -p 233 -P 233 -p 2710 -p 6969 &
		#ipv6监听tcp:666、udp:2710+6969
		opentracker6 -p 666 -P 2710 -P 6969 &
		logger -t "opentracker6启动成功"
		else
			logger -t "opentracker6已启动or未知失败"
			exit 1
	fi
fi
