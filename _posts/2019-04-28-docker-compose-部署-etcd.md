---
layout: post
title: docker-compose 部署 etcd
date: 2019-04-28 17:43:16 +0800
categories: etcd
tags: [etcd, docker-compose]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

参考官方的 release 信息整理 docker-compse 编排文件的配置参数，实现一键创建 etcd 容器，并演示相关操作。

## docker 部署 etcd

### docker-compse.yml 配置文件

``` yaml
version: '2.2'
services:
  etcd:
    image: quay.io/coreos/etcd:v3.3.12
    container_name: etcd-v3
    ports:
      - 2379:2379
      - 2380:2380
    environment:
      ETCDCTL_API: 3
    volumes:
      - /Users/owenliu/lehui/data/etcd/etcd-data:/etcd-data
    command:
      - "/usr/local/bin/etcd"
      - "--name"
      - "s1"
      - "--data-dir"
      - "/etcd-data"
      - "--advertise-client-urls"
      - "http://0.0.0.0:2379"
      - --listen-client-urls
      - "http://0.0.0.0:2379"
      - "--initial-advertise-peer-urls"
      - "http://0.0.0.0:2380"
      - "--listen-peer-urls"
      - "http://0.0.0.0:2380"
      - "--initial-cluster-token"
      - "tkn"
      - "--initial-cluster"
      - "s1=http://0.0.0.0:2380"
      - "--initial-cluster-state"
      - "new"
```

### docker-compose 参数说明

#### volumes

我们把宿主机的目录映射到容器的 /etcd-data 目录目的是，每次重新创建容器，数据不会清空

#### ETCDCTL_API

这个环境变量来指定 etcdctl 的 API 版本，2 和 3 的命令执行方式是不一样的

1. `export ETCDCTL_API=2`
    ![2019-04-28-18-11-47](/images/2019-04-28-18-11-47.png)

2. `export ETCDCTL_API=3`
    ![2019-04-28-18-16-31](/images/2019-04-28-18-16-31.png)

#### command

这里的书写方式支持多种，是等效的，我就是使用第三个书写方法。

1. 直接一行字符串，这就是我们正常使用的例如 `command: bundle exec thin -p 3000`

    ``` yaml
    command: "/usr/local/bin/etcd --name s1 --data-dir /etcd-data --advertise-client-urls http://0.0.0.0:2379 --listen-client-urls http://0.0.0.0:2379 --initial-advertise-peer-urls http://0.0.0.0:2380 --listen-peer-urls http://0.0.0.0:2380 --initial-cluster-token tkn --initial-cluster s1=http://0.0.0.0:2380 --initial-cluster-state new"
    ```

2. 方括号数组方式，例如 `command: [bundle, exec, thin, -p, 3000]`

    ``` yaml
    command: ["/usr/local/bin/etcd", "--name", "s1", "--data-dir", "/etcd-data" "--advertise-client-urls", "http://0.0.0.0:2379", "--listen-client-urls", "http://0.0.0.0:2379", "--initial-advertise-peer-urls", "http://0.0.0.0:2380", "--listen-peer-urls", "http://0.0.0.0:2380", "--initial-cluster-token", "tkn", "--initial-cluster", "s1=http://0.0.0.0:2380", "--initial-cluster-state", "new"]
    ```

3. yaml 数组方式，我就是使用的这种方式，所以就不写完整的了例如：

    ``` yaml
    command: [bundle, exec, thin, -p, 3000]
    ```

### 测试 etcd 服务

1. 登入容器内部 `docker exec -it etcd-v3 /bin/sh`

2. 查看 ETCDCTL_API, `echo $ETCDCTL_API`
    ![2019-04-28-18-25-04](/images/2019-04-28-18-25-04.png)

3. 查看 etcd 版本 `etcd --version`
    ![2019-04-28-18-31-28](/images/2019-04-28-18-31-28.png)

4. 查看 etcdctl 版本 `etcdctl version`, 如果 api 版本是 2，命令是 `etcdctl -v`
    ![2019-04-28-18-32-19](/images/2019-04-28-18-32-19.png)

5. put k-v 值 `etcdctl put foo bar`

6. get k 值 `etcdctl foo`

7. 登出容器，如果宿主机安装了 etcdctl 命令，通过也可 put/get 容器内 etcd 的 k-v 值，因为我们创建容器时候是有端口映射的

### MacOS 安装 etcd 以及 etcdctl

安装 etcd 包含 etcd 和 etcdctl, 我这里只是为了使用 etcdctl 命令，网上说也可以使用 `brew install etcdctl` 这个命令，只安装 etcdctl 命令，但是我测试是不行的，所以就安装了 etcd

``` shell
brew install etcd
```

参考链接：

[etcd release 官方启动命令](https://github.com/etcd-io/etcd/releases)

[docker-compose 命令](<https://www.cnblogs.com/regit/p/8309959.html>)

[使用docker-compse编排容器](<https://www.hi-linux.com/posts/12554.html>)