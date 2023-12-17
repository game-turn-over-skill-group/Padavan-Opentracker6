# Padavan-Opentracker6
#### 使用老毛子Padavan路由器固件-安装Opentracker6


```css
[NewWifi-3 /opt/home/admin]# opkg update

[NewWifi-3 /opt/home/admin]# opkg install opentracker6
```



#### 特别说明一下 只需要安装 opentracker6 就行了 就支持ipv4+ipv6 如果你只需要ipv4就安装 不带6字的

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
#### 进程连接 【netstat -apn|grep opentracker | wc -l】
#### 查看CPU 【top -b -n 1 |grep opentracker】

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

`然后是断电脚本 这个我也配置了 但是还没测试 大致说一下吧 弄个文件名 SH102_opentracker6_Install.sh`

`SH102这个数字你可能要根据你看到的脚本来排序来改 WinSCP连接路由器 `

`丢到【/etc/storage/script/】目录下 每次断电启动后 循环执行里面的脚本`

`但是我要提醒你 必须稳定测试了 再去配置脚本 没个十几二十天 稳定的话 建议不要啥都往路由器安装。。`

`我之前配置socat就是不小心输入错命令死了 还好重启路由器 能恢复`

## 配置断电自动更新脚本(UTF-8格式)  
<details>
<summary> 点击：隐藏/显示【Click: Hide/Show】 </summary>

$\color{green}{如果你挂载了USB盘的OPT 可以跳过这一步}$

```sh
#!/bin/sh
logger -t "开始更新opentracker6"
opkg update
sleep 10
opkg install opentracker6
logger -t "opentracker6安装成功"
sleep 5
logger -t "正在启动...opentracker6：ipv6监听tcp:233、tcp:2710+6969"
sleep 120
opentracker6 -p 233 -p 2710 -p 6969 &
sleep 30
logger -t "正在启动...opentracker6：ipv6监听tcp:666、udp:2710+6969"
opentracker6 -p 666 -P 2710 -P 6969 &

logger -t "opentracker6启动成功"
```
`最后再提一下 脚本还没测试 等我测试报告 肯定是有点小问题 能不能用 我不知道 微软AI【copilot】教我写的……`

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




