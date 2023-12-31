#!/bin/sh
#查找opentracker6安装路径;如果退出状态不为0(未安装),则开始安装更新;安装后写入txt判断内容:是否安装成功。
which opentracker6
if [ $? -ne 0 ]; then
	echo "开始更新opentracker6"
	opkg update && opkg install opentracker6 | tee opt6_log.txt
	if [ -n "$(grep "Configuring opentracker" opt6_log.txt)" ]; then
		echo "opentracker6安装成功"
		logger -t "【opentracker6】" "安装成功"
		else
			echo "opentracker6安装失败"
			exit 1
	fi

fi

#我睡5秒觉 没毛病吧？
#echo "正在启动...opentracker6"
#sleep 5

#查找opentracker6安装路径;如果退出状态等于0(已安装),则启动;检测进程是否存在，如果不存在则启动，如果存在则提示。
which opentracker6
if [ $? -eq 0 ]; then
	#ipv6监听tcp:233、tcp:2710+6969
	result1=$(top -b -n 1 | grep "opentracker6 -p 233 -P 233 -p 2710 -p 6969" | wc -l)
	if [ $result1 = "1" ]; then
		opentracker6 -p 233 -P 233 -p 2710 -p 6969 &
		echo "【opentracker6】进程233启动成功"
		logger -t "【opentracker6】" "进程233启动成功"
	else
		echo "【opentracker6】进程233已启动"
	fi
	#ipv6监听tcp:666、udp:2710+6969
	result2=$(top -b -n 1 | grep "opentracker6 -p 666 -P 2710 -P 6969" | wc -l)
	if [ $result2 = "1" ]; then
		opentracker6 -p 666 -P 2710 -P 6969 &
		echo "【opentracker6】进程666启动成功"
		logger -t "【opentracker6】" "进程666启动成功"
	else
		echo "【opentracker6】进程666已启动"
	fi
fi
