# Padavan-Opentracker6
#### 使用老毛子Padavan路由器固件-安装Opentracker6


```css
[NewWifi-3 /opt/home/admin]# opkg update

[NewWifi-3 /opt/home/admin]# opkg install opentracker6
```



#### 特别说明一下 只需要安装 opentracker6 就行了 就支持ipv4+ipv6 如果你只需要ipv4就安装 不带6字的

```
 [2024年12月01日 17:46:44] 补充说明:
 http ipv4 需要安装 opentracker 不然部分应用不会返回ip 比如Tixati 虽然比特彗星会返回 但是还是建议分离开启动 
 如果使用樱酱安装编译的tracker 则不需要区分应用
```

![配置opentracker6](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/55a3deaa99fad31effecca4a66d01c19dc5483dc/%E9%85%8D%E7%BD%AEopentracker6.png)

![opt安装包](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/55a3deaa99fad31effecca4a66d01c19dc5483dc/opentracker%E5%AE%89%E8%A3%85%E5%8C%85.png)

![路由器opt设置](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/dac1a9fa47b2d2620334c701863c0291d3f150f4/%E8%B7%AF%E7%94%B1%E5%99%A8%E5%90%AF%E5%8A%A8OPT.jpg)

#### 这个路由器opt设置 很关键 不然你无法使用opkg命令。。
`也是我无意间 在写socat命令转发 把网络搞炸 重启路由器后发现的`

#### 路由器脚本会每次断电重启后重新挂载OPT 如果你没有USB盘 载入EXT4格式的话。。

`我以前是有的 绿联的USB盘 不知道啥时候炸了 真是路由器都没坏USB炸了。。回头再去买不过这次肯定买品牌（闪迪、金士顿、西数）`

#### 然后说一下 怎么启动 配置参考了 樱酱写的文章：
##### 配置教程：https://bbs.itzmx.com/thread-18214-1-1.html

我下面简单描述一下

#### 查看网络【netstat -apn】
#### 统计连接 【netstat -apn|grep opentracker | wc -l】
#### 查看CPU 【top -b -n 1 |grep opentracker】
#### 连接详情【netstat -ant |grep 2710 |awk ' {++S [$NF]} END {for (a in S) print a, S [a]}'】

`opentracker启动！小写 -p=tcp 大写 -P=udp`
```css
[NewWifi-3 /opt/home/admin]# opentracker6 -p 2710 -P 2710 &
```
#### ipv4+ipv6【opentracker6 -p 2710 -P 2710 &】 tcp+udp的2710端口
`&符号代表后台启动的意思 命令是输入括号内的内容……`

PS：我不是这么配置的 只是举例子 我的tcp和udp分离 另外自己再开个端口和进程一起启动 用那个端口来监控

## 配置ip6tables防火墙 (下面这个脚本配置到 防火墙启动后执行 里面)
`8999是我的QBT用的 你们自己改改添加就好`
```php
# 开通IPV6 内网端口（内网的IPV6 就能通端口了）
ip6tables -A FORWARD -p tcp -m multiport --dports 2710,6969,8999 -j ACCEPT
ip6tables -A FORWARD -p udp -m multiport --dports 2710,6969,8999 -j ACCEPT
# 开通IPV6 外网访问（路由器的这些端口 能被访问）
ip6tables -A INPUT -p tcp -m multiport --dports 2710,6969 -j ACCEPT
ip6tables -A INPUT -p udp -m multiport --dports 2710,6969 -j ACCEPT

```


##### ipv6你只要把路由器获取到的IPV6地址设置DDNS就好了 ipv4你需要设置NAT端口转发到你的路由器IP+端口
#### 路由器挂TCP+ipv6就好了 udp的ipv4转发到内网IP来跑 减少路由器压力……（我的建议 当然你也可以不听） 
`……这就是另一个故事了 我以前写过 一篇文章 提到`<a href=https://github.com/lirener/lirener.github.io/wiki/%E4%BD%BF%E7%94%A8node%E5%AE%89%E8%A3%85bittorrent-tracker%E5%BB%BA%E7%AB%8Btracker%E6%9C%8D%E5%8A%A1%E5%99%A8(%E6%95%99%E7%A8%8B)>如何配置node.js搭建tracker server</a>

`别看我就说了这么多 我研究tracker移植 从exe到node.js再到php再到Linux(路由器)`

`总结我也要提一下：IPV6的nat基本是放弃了 socat转发过来的IP是本地IP 不管从路由器还是电脑我都试过了`

`光是研究这个tracker server的配置 我对着微软的AI-copilot各种问 文本记录都有30K了。。`


## 配置断电(重启)自动更新脚本(UTF-8格式)  
<details>
<summary> 点击：隐藏/显示【Click: Hide/Show】 </summary>

![上传文件后给与可执行权限](https://github.com/game-turn-over-skill-group/Padavan-Opentracker6/blob/main/%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6%E5%90%8E%E7%BB%99%E4%B8%8E%E5%8F%AF%E6%89%A7%E8%A1%8C%E6%9D%83%E9%99%90%EF%BC%81.png)

`脚本命名为“Opentracker6_Install_Start.sh”  WinSCP连接路由器 丢到【/etc/storage/】目录下`

`上传文件后必须右击属性 3个X的可执行权限打勾✔ `

`在路由器启动后执行 添加下面命令(脚本在项目中下载)`

```php
# 路由器启动后 执行1次重启crond进程 移除日志记录等级为8
/etc/storage/script/restart_crond.sh keep &
```
![添加路由器启动后执行脚本](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/ac967a33dda064824a1e66c8f7a6aca6c1437713/%E6%B7%BB%E5%8A%A0%E8%B7%AF%E7%94%B1%E5%99%A8%E5%90%AF%E5%8A%A8%E5%90%8E%E6%89%A7%E8%A1%8C%E8%84%9A%E6%9C%AC.jpg)

`在定时计划任务中 添加下面命令(脚本在项目中下载 以下展示内容不能保证最新)`

```php
# 每1分钟 更新并启动opentracker6 （因为在自定义脚本中添加更新也没办法保证启动）
*/1 * * * * /etc/storage/Opentracker6_Install_Start.sh & 
# 写入日志查看错误信息模式
#*/1 * * * * /bin/sh /etc/storage/Opentracker6_Install_Start.sh >> /opt/tmp/cron_opentracker6.log 2>&1
```
![计划任务脚本](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/b18dc4411e8ff213bfd50b5a27032dbf1164b065/%E8%AE%A1%E5%88%92%E4%BB%BB%E5%8A%A1%E8%84%9A%E6%9C%AC.jpg)

```sh
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

```

`和微软AI【copilot】4.0精准引擎 通宵畅聊几小时且经过测试后 修改出来的脚本 大概率是没毛病了(还是有毛病不过修复了)`

`直接找总部chatGPT帮我改脚本 经过一系列调试之后解决了部分命令在计划任务中 不支持的问题……`

</details>

## 配置DDNS(路由器)cloudflare（CF）
```sh
# 获取IPV6 LAN口
ifconfig $(nvram get lan0_ifname_t) | awk '/Global/{print $3}' | awk -F/ '{print $1}' | head -n 1
```
`IPV6 udp 经过测试 WAN不工作 LAN工作  默认是配置WAN口的更新 所以我找AI替换了更新接口改为LAN `

![配置DDNS脚本](https://raw.githubusercontent.com/game-turn-over-skill-group/Padavan-Opentracker6/2df19f84b281472787a3d3b05b6ee83a56c92095/%E9%85%8D%E7%BD%AEDDNS%E8%84%9A%E6%9C%AC.jpg)

-----------------------------------------

#### 经过我这一段时间的测试 汇报一下测试结果 如下：

opentracker的TCP(http)基本正常工作 ipv4+ipv6(tcp)=OK

opentracker的UDP国内IPV6=OK IPV4=NO 国外似乎都不工作?我觉得很大一部分可能和应用有关系！

node.js（BT—tracker）UDP国内外 ipv4+ipv6=OK

node.js（BT—tracker）TCP(http) 用户数量达到一定程度会卡顿系统和影响UDP链路程序卡顿 =半工作

`关于IPV6的UDP我有必要说一下QBT的node.js显示不工作 Tixia正常`

`所以IPV6存在很多应用兼容性不能的问题 opentracker的话QBT就显示工作`

#### 所以答案很明显了 推荐：http（opentracker）、udp（node.js）




