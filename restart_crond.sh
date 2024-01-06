#!/bin/sh
# 主逻辑函数
main_logic() {
    # 在这里放入你的主逻辑代码，例如结束旧的 crond 进程，启动新的 crond 进程
    # 唯一性检测判断是crond进程 排除包含：-d8参数的进程+脚本自身+grep命令 如果查询结果为0=真 执行结束进程并启动
    ps w | grep "[c]rond" | grep -v "/usr/sbin/crond -d8" | grep -v "restart_crond.sh" | grep -v grep > /dev/null
    if [ $? -eq 0 ]; then
    	killall crond && /usr/sbin/crond -d8
    	logger -t "【restart_crond.sh】" "crond进程重启成功/过滤计划任务调试模式"
    fi
}
# 无限循环
while true; do
    # 执行主逻辑
    main_logic

    # 等待2分钟
    sleep 120
done