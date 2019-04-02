---
layout: post
title:  "[转]Nginx 配置多域名 http转https"
date:   2019-04-02 14:17:23 +0800
categories: Nginx
tags: 
  - https
  - nginx
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---
之前实现了用Let ’ s Encrypt 生成SSL证书，现在将全部的域名强制实现https访问

### 一.备份之前配置文件，创建新的配置文件

#### 1.进入nginx conf目录，并创建备份文件夹

```
cd /user/local/nginx/conf

mkdir vhost.conf.bak
```

#### 2.将旧的配置文件移动到备份文件夹

```
mv vhost/* conf.vhost.bak/
```

#### 3.创建新的配置文件

创建主配置文件负责监听80端口并转发请求

```
vim index.host.conf
```

内容如下：

```
server {
    listen 80;
    server_name abc.cn www.abc.cn jenkins.abc.cn mymaven.abc.cn dubboadmin.abc.cn;
    rewrite ^(.*) https://$host permanent;
}
```

创建各域名配置文件监听443端口（可以按域名分开，也可以写一个文件里，我为了方便写在一个文件里）

```
vim https.host.conf
```

内容如下：

```
 server {
        listen       443;
        server_name  www.mrpei.cn  mrpei.cn;

        ssl on;
        ssl_certificate      /etc/letsencrypt/live/mrpei.cn-0002/fullchain.pem;
        ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn-0002/privkey.pem;
        
        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
			proxy_pass http://112.74.102.226:8080/;
            proxy_set_header Host       $http_host;
			proxy_set_header X-Real-IP $remote_addr;  
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
			proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
 server {
        listen       443;
        server_name  jenkins.mrpei.cn;

        ssl on;
        ssl_certificate      /etc/letsencrypt/live/mrpei.cn-0002/fullchain.pem;
        ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn-0002/privkey.pem;
        
        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
			proxy_pass http://112.74.102.226:8300;
			proxy_set_header Host       $http_host;
			proxy_set_header X-Real-IP $remote_addr;  
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
			proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
	
 server {
        listen       443;
        server_name  mymaven.mrpei.cn;

        ssl on;
        ssl_certificate      /etc/letsencrypt/live/mrpei.cn-0002/fullchain.pem;
        ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn-0002/privkey.pem;
        
        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
			proxy_pass http://112.74.102.226:8081;
			proxy_set_header Host       $http_host;
			proxy_set_header X-Real-IP $remote_addr;  
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
			proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
	
 server {
        listen       443;
        server_name  dubboadmin.mrpei.cn;

        ssl on;
        ssl_certificate      /etc/letsencrypt/live/mrpei.cn-0002/fullchain.pem;
        ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn-0002/privkey.pem;
        
        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
			proxy_pass http://127.0.0.1:8080;
			proxy_set_header Host       $http_host;
			proxy_set_header X-Real-IP $remote_addr;  
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
			proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
	
```



### 二.测试并启用新的配置文件

返回nginx根目录，执行配置文件测试

```
cd ../
sbin/nginx -t
```

显示如下输出表示测试通过

```
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

以新的配置文件重启Nginx

```
sbin/nginx -s reload
```

### 三.再次访问之前的地址 看到浏览器自动转到https

### 四.出现的问题

#### 1.有的域名浏览器地址栏https报红，提示连接不安全

这是因为有的域名并没有加入之前的申请证书

再次执行申请证书命令并-d追加所有需要的域名

```
cd /usr/server/sslKey/letsencrypt/
./letsencrypt-auto certonly --standalone --email 756487195@qq.com -d abc.cn -d jenkins.abc.cn -d mymaven.abc.cn -d dubboadmin.abc.cn
```

特别注意：如果没有删除以前的公钥私钥证书 生成结果会生成新的两个文件 注意修改 Nginx 配置文件对应的文件名

如下图：

![2019-04-02-14-21-55](/images/2019-04-02-14-21-55.png)

修改位置：

```
ssl_certificate      /etc/letsencrypt/live/mrpei.cn/fullchain.pem;
ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn/privkey.pem;
```

修改为：

```
ssl_certificate      /etc/letsencrypt/live/mrpei.cn-0002/fullchain.pem;
ssl_certificate_key  /etc/letsencrypt/live/mrpei.cn-0002/privkey.pem;
```

...

原文链接：https://my.oschina.net/mrpei123/blog/1794001