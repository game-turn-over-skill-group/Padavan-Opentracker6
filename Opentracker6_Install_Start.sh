#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin"

# 判断opentracker6安装路径是否为空
if [ -z "$(which opentracker6)" ]; then
    # 如果未安装，执行安装命令
    opkg update && opkg install opentracker6 > /opt/tmp/opt6_log.txt 2>&1

    if [ -n "$(grep "Configuring opentracker6" /opt/tmp/opt6_log.txt)" ]; then
        echo "【opentracker6】安装成功"
        logger -t "【opentracker6】" "安装成功"
    elif [ -n "$(grep "installed in root is up to date" /opt/tmp/opt6_log.txt)" ]; then
        echo "【opentracker6】已安装，无需重复安装。"
        logger -t "【opentracker6】" "已安装，无需重复安装。"
    else
        echo "【opentracker6】安装失败"
        logger -t "【opentracker6】" "安装失败"
    fi
else
    echo "【opentracker6】已安装"
fi

# 判断opentracker6是否安装，如果安装，开始执行下面的操作
if [[ $(which opentracker6) == "/opt/bin/opentracker6" ]]; then
    # ipv6监听tcp:233、tcp:2710+6969
    result1=$(top -b -n 1 | grep "opentracker6 -p 233 -P 233 -p 2710 -p 6969" | wc -l)
    if [ $result1 = "1" ]; then
        opentracker6 -p 233 -P 233 -p 2710 -p 6969 &
        echo "【opentracker6】进程233启动成功"
        logger -t "【opentracker6】" "进程233启动成功"
    else
        echo "【opentracker6】进程233已启动"
    fi

    # ipv6监听tcp:666、udp:2710+6969
    result2=$(top -b -n 1 | grep "opentracker6 -p 666 -P 2710 -P 6969" | wc -l)
    if [ $result2 = "1" ]; then
        opentracker6 -p 666 -P 2710 -P 6969 &
        echo "【opentracker6】进程666启动成功"
        logger -t "【opentracker6】" "进程666启动成功"
    else
        echo "【opentracker6】进程666已启动"
    fi
fi
