＃！/ bin / bash
函数blue（）{
    echo -e“ \ 033 [34m \ 033 [01m $ 1 \ 033 [0m]”
}
函数green（）{
    echo -e“ \ 033 [32m \ 033 [01m $ 1 \ 033 [0m]”
}
函数red（）{
    echo -e“ \ 033 [31m \ 033 [01m $ 1 \ 033 [0m]”
}
函数yellow（）{
    echo -e“ \ 033 [33m \ 033 [01m $ 1 \ 033 [0m]”
}

函数check_os（）{
绿色“系统支持检测”
睡眠3秒
如果[[-f / etc / redhat-release]]; 然后
    release =“ centos”
    systemPackage =“ yum”
猫猫/ etc / issue | grep -Eqi“ debian”; 然后
    release =“ debian”
    systemPackage =“ apt-get”
猫猫/ etc / issue | grep -Eqi“ ubuntu”; 然后
    release =“ ubuntu”
    systemPackage =“ apt-get”
猫猫/ etc / issue | grep -Eqi“ centos | red hat | redhat”; 然后
    release =“ centos”
    systemPackage =“ yum”
小精灵猫/ proc / version | grep -Eqi“ debian”; 然后
    release =“ debian”
    systemPackage =“ apt-get”
小精灵猫/ proc / version | grep -Eqi“ ubuntu”; 然后
    release =“ ubuntu”
    systemPackage =“ apt-get”
小精灵猫/ proc / version | grep -Eqi“ centos | red hat | redhat”; 然后
    release =“ centos”
    systemPackage =“ yum”
科幻
如果[“ $ release” ==“ centos”]; 然后
    如果[-n“ $（grep'6 \。'/ etc / redhat-release）”]；然后
    红色“ ===============”
    红色“当前系统不受支持”
    红色“ ===============”
    出口
    科幻
    如果[-n“ $（grep'5 \。'/ etc / redhat-release）”]；然后
    红色“ ===============”
    红色“当前系统不受支持”
    红色“ ===============”
    出口
    科幻
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm> / dev / null 2>＆1
    绿色“开始安装nginx编译依赖”
    yum install -y libtool perl-core zlib-devel gcc pcre *> / dev / null 2>＆1
elif [“ $ release” ==“ ubuntu”]; 然后
    如果[-n“ $（grep'14 \。'/ etc / os-release）”]；然后
    红色“ ===============”
    红色“当前系统不受支持”
    红色“ ===============”
    出口
    科幻
    如果[-n“ $（grep'12 \。'/ etc / os-release）”]；然后
    红色“ ===============”
    红色“当前系统不受支持”
    红色“ ===============”
    出口
    科幻
    ufw_status =`systemctl状态ufw | grep“活动：活动”`
    如果[-n“ $ ufw_status”]; 然后
        ufw允许80 / tcp
        ufw允许443 / tcp
    科幻
    apt-get更新> / dev / null 2>＆1
    绿色“开始安装nginx编译依赖”
    apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g-dev liblua5.1-dev libluajit-5.1-dev libgeoip-dev google-perftools libgoogle-perftools-dev> / dev / null 2>＆1
elif [“ $ release” ==“ debian”]; 然后
    apt-get更新> / dev / null 2>＆1
    绿色“开始安装nginx编译依赖”
    apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g-dev liblua5.1-dev libluajit-5.1-dev libgeoip-dev google-perftools libgoogle-perftools-dev> / dev / null 2>＆1
科幻
}

函数check_env（）{
绿色“安装环境监测”
睡眠3秒
如果[-f“ / etc / selinux / config”]; 然后
    CHECK = $（grep SELINUX = / etc / selinux / config | grep -v“＃”）
    如果[“ $ CHECK”！=“ SELINUX = disabled”]; 然后
        绿色“检测到SELinux开启状态，添加开放80/443端口规则”
	yum install -y policycoreutils-python> / dev / null 2>＆1
        管理端口-m -t http_port_t -p tcp 80
        管理端口-m -t http_port_t -p tcp 443
    科幻
科幻
firewall_status =`firewall-cmd --state`
如果[“ $ firewall_status” ==“正在运行”]; 然后
    绿色“检测到firewalld开启状态，添加放行80/443端口规则”
    防火墙cmd --zone = public --add-port = 80 / tcp --permanent
    防火墙cmd --zone = public --add-port = 443 / tcp --permanent
    防火墙cmd-重新加载
科幻
$ systemPackage -y install net-tools socat> / dev / null 2>＆1
Port80 =`netstat -tlpn | awk -F'[：] +''$ 1 ==“ tcp” {print $ 5}'| grep -w 80`
端口443 =`netstat -tlpn | awk -F'[：] +''$ 1 ==“ tcp” {print $ 5}'| grep -w 443`
如果[-n“ $ Port80”]; 然后
    process80 =`netstat -tlpn | awk -F'[：] +''$ 5 ==“ 80” {print $ 9}'`
    红色“ ================================================= ===========
    红色“检测到80端口被占用，占用进程为：$ {process80}，本次安装结束”
    红色“ ================================================= ===========
    1号出口
科幻
如果[-n“ $ Port443”]; 然后
    process443 =`netstat -tlpn | awk -F'[：] +''$ 5 ==“ 443” {print $ 9}'`
    红色“ ================================================ =============
    红色“检测到443端口被占用，占用进程为：$ {process443}，本次安装结束”
    红色“ ================================================ =============
    1号出口
科幻
}
函数install_nginx（）{

    wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1a.tar.gz> / dev / null 2>＆1
    tar xzvf openssl-1.1.1a.tar.gz> / dev / null 2>＆1
    mkdir / etc / nginx
    mkdir / etc / nginx / ssl
    mkdir /etc/nginx/conf.d
    wget https://nginx.org/download/nginx-1.15.8.tar.gz> / dev / null 2>＆1
    tar xf nginx-1.15.8.tar.gz && rm nginx-1.15.8.tar.gz> / dev / null 2>＆1
    光盘nginx-1.15.8
    ./configure --prefix = / etc / nginx --with-openssl = .. / openssl-1.1.1a --with-openssl-opt ='enable-tls1_3'--with-http_v2_module --with-http_ssl_module- with-http_gzip_static_module --with-http_stub_status_module --with-http_sub_module --with-stream --with-stream_ssl_module> / dev / null 2>＆1
    green“开始编译安装nginx，编译等待时间可能要，请耐心等待，通常需要几到几十分钟”
    睡眠3秒
    使> / dev / null 2>＆1
    进行安装> / dev / null 2>＆1
    
猫> /etc/nginx/conf/nginx.conf <<-EOF
用户根；
worker_processes 1;
error_log /etc/nginx/logs/error.log警告；
pid /etc/nginx/logs/nginx.pid;
事件{
    worker_connections 1024;
}
http {
    包括/etc/nginx/conf/mime.types;
    default_type应用程序/八位字节流；
    log_format main'\ $ remote_addr-\ $ remote_user [\ $ time_local]“ \ $ request”'
                      '\ $ status \ $ body_bytes_sent“ \ $ http_referer”'
                      '“ \ $ http_user_agent”“ \ $ http_x_forwarded_for”“;
    access_log /etc/nginx/logs/access.log main;
    发送文件
    #tcp_nopush on;
    keepalive_timeout 120;
    client_max_body_size 20m;
    #gzip on;
    包括/etc/nginx/conf.d/*.conf;
}
EOF
    卷曲https://get.acme.sh | SH
    〜/ .acme.sh / acme.sh --issue -d $ your_domain --standalone
    〜/ .acme.sh / acme.sh --installcert -d $您的域\
        --key-file /etc/nginx/ssl/$your_domain.key \
        --fullchain-文件/etc/nginx/ssl/fullchain.cer
    newpath = $（cat / dev / urandom |头-1 | md5sum |头-c 4）
猫> /etc/nginx/conf.d/default.conf<<-EOF
服务器{ 
    听80;
    server_name $ your_domain;
    重写^（。*）$ https：// \ $ host \ $ 1永久; 
}
服务器{
    监听443 SSL http2;
    server_name $ your_domain;
    根/ etc / nginx / html;
    index index.php index.html;
    ssl_certificate /etc/nginx/ssl/fullchain.cer; 
    ssl_certificate_key /etc/nginx/ssl/$your_domain.key;
    #TLS版本控制
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers'TLS13-AES-256-GCM-SHA384：TLS13-CHACHA20-POLY1305-SHA256：TLS13-AES-128-GCM-SHA256：TLS13-AES-128-CCM-8-SHA256：TLS13-AES-128-CCM- SHA256：EECDH + CHACHA20：EECDH + CHACHA20草稿：EECDH + ECDSA + AES128：EECDH + aRSA + AES128：RSA + AES128：EECDH + ECDSA + AES256：EECDH + aRSA + AES256：RSA + AES256：EECDH + ECDSA + 3DES： EECDH + aRSA + 3DES：RSA + 3DES：！MD5';
    ssl_prefer_server_ciphers;
    ＃开启1.3 0-RTT
    ssl_early_data;
    ssl_stapling on;
    ssl_stapling_verify on;
    #add_header严格的传输安全性“ max-age = 31536000”;
    #access_log /var/log/nginx/access.log组合；
    位置/ $ newpath {
        proxy_redirect关闭；
        proxy_pass http://127.0.0.1:11234; 
        proxy_http_version 1.1;
        proxy_set_header升级\ $ http_upgrade;
        proxy_set_header连接“升级”；
        proxy_set_header主机\ $ http_host;
    }
}
EOF
猫> /etc/systemd/system/nginx.service<<-EOF
[单元]
Description = nginx服务
之后= network.target 
   
[服务] 
类型=分叉 
ExecStart = / etc / nginx / sbin / nginx
ExecReload = / etc / nginx / sbin / nginx -s重新加载
ExecStop = / etc / nginx / sbin / nginx -s退出
PrivateTmp = true 
   
[安装] 
WantedBy =多用户目标
EOF
chmod 777 /etc/systemd/system/nginx.service
systemctl启用nginx.service
install_v2ray
}

＃安装nginx
函数install（）{
    $ systemPackage install -y wget curl解压缩> / dev / null 2>＆1
    绿色“ ======================”
    蓝色“请输入绑定到本VPS的域名”
    绿色“ ======================”
    阅读your_domain
    real_addr =`ping $ {your_domain} -c 1 | sed'1 {s / [^（] *（//; s /).*//; q}'``
    local_addr =`curl ipv4.icanhazip.com`
    如果[$ real_addr == $ local_addr]; 然后
        绿色“ ========================================
	绿色“域名解析正常，开始安装”
	绿色“ ========================================
        install_nginx
    其他
        红色“ ===================================
	红色“域名解析地址与本VPS IP地址重复”
	红色“如果你确认解析成功你可强制脚本继续运行”
	红色“ ===================================
	读取-p“是否强制运行？请输入[Y / n]：” yn
	[-z“ $ {yn}”] && yn =“ y”
	如果[[$ yn == [Yy]]]; 然后
            绿色“强制继续运行脚本”
	    睡1s
	    install_nginx
	其他
	    1号出口
	科幻
    科幻
}
＃安装v2ray
函数install_v2ray（）{
    
    #bash <（curl -L -s https://install.direct/go.sh）  
    bash <（curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh） 
    cd / usr / local / etc / v2ray /
    rm -f config.json
    wget https://raw.githubusercontent.com/atrandys/v2ray-ws-tls/master/config.json> / dev / null 2>＆1
    v2uuid = $（cat / proc / sys / kernel / random / uuid）
    sed -i“ s / aaaa / $ v2uuid /;” config.json
    sed -i“ s / mypath / $ newpath /;” config.json
    cd / etc / nginx / html
    rm -f ./*
    wget https://github.com/atrandys/v2ray-ws-tls/raw/master/web.zip> / dev / null 2>＆1
    解压缩web.zip> / dev / null 2>＆1
    systemctl重新启动v2ray.service
    systemctl重新启动nginx.service    
    
猫> /usr/local/etc/v2ray/myconfig.json<<-EOF
{
==========配置参数============
地址：$ {your_domain}
进度：443
uuid：$ {v2uuid}
额外id：64
加密方式：aes-128-gcm
传输协议：ws
别名：myws
路径：$ {newpath}
急剧传输：tls
}
EOF

绿色“ =============================”
绿色“安装已经完成”
绿色“ ==========配置参数============”
绿色“地址：$ {您的域}”
绿色“端口：443”
绿色的“ uuid：$ {v2uuid}”
绿色“额外id：64”
绿色“加密方式：aes-128-gcm”
绿色“传输协议：ws”
绿色“别名：myws”
绿色“路径：$ {newpath}”
绿色“灵活传输：tls”
绿色 
}

函数remove_v2ray（）{

    / etc / nginx / sbin / nginx -s停止
    systemctl stop v2ray.service
    systemctl禁用v2ray.service
    
    rm -rf / usr / local / bin / v2ray / usr / local / bin / v2ctl
    rm -rf / usr / local / share / v2ray / / usr / local / etc / v2ray /
    rm -rf / etc / systemd / system / v2ray *
    rm -rf / etc / nginx
    
    绿色“ nginx，v2ray已删除”
    
}

函数start_menu（）{
    明确
    绿色“ =============================================
    绿色“信息：一键脚本安装v2ray + ws + tls”
    绿色“操作系统支持：centos7 / debian9 + / ubuntu16.04 +”
    绿色“作者：A”
    绿色“ =============================================
    回声
    绿色“ 1.安装v2ray + ws + tls1.3”
    绿色“ 2.更新v2ray”
    红色“ 3.删除v2ray”
    黄色“0。退出”
    回声
    读取-p“请输入数字：” num
    情况为“ $ num”
    1）
    check_os
    check_env
    安装
    ;;
    2）
    bash <（curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh）
    systemctl重新启动v2ray
    ;;
    3）
    remove_v2ray 
    ;;
    0）
    1号出口
    ;;
    *）
    明确
    红色“输入正确的号码”
    睡2s
    开始菜单
    ;;
    埃萨克
}

开始菜单
