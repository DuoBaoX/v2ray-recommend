#使用SSH工具连接VPS，执行下列命令，选择安装v2ray+ws+tls

curl -O https://raw.githubusercontent.com/DuoBaoX/v2ray-ws-tls/master/v2ray_ws_tls1.3.sh && chmod +x v2ray_ws_tls1.3.sh && ./v2ray_ws_tls1.3.sh

##先放个一键脚本，修复了很久之前的v2ray+ws+tls1.3脚本，之前因为官方安装脚本更新无法使用，目前已正常使用。同时copy了一份稍微修改了一下配置文件，改为vless+ws+tls1.3的一键脚本，目前已测试centos7/ubuntu18.04/debian10均可以正常使用。

bash <(curl -L -s https://raw.githubusercontent.com/DuoBaoX/v2ray-ws-tls/master/vless_ws_tls.sh)

##使用SSH工具连接VPS，执行下列命令，vless+tcp+tls一键脚本
bash <(curl -L -s https://raw.githubusercontent.com/DuoBaoX/v2ray-ws-tls/master/vless_tcp_tls.sh)

#BBR加速器：执行下列命令，选择安装，建议安装原版BBR

cd /usr/src && wget -N --no-check-certificate "https://raw.githubusercontent.com/DuoBaoX/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh



原创文章，作者：atrandys，如若转载，请注明出处：https://www.atrandys.com/2020/30.html

