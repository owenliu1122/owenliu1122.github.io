---
layout: post
title: 使用 Docker 部署 Grafana + Prometheus 监控 etcd 集群
date: 2019-04-29 11:00:56 +0800
categories: etcd
tags: [docker-compose, grafana, prometheus]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

本文介绍 docker-compose 部署 etcd 集群的监控，使用的是 prometheus + grafana 的方式。

## 配置 docker-compse.yml 文件

``` yaml
version: '2'
services:

  prometheus:
    container_name: prometheus
    image: prom/prometheus
    ports:
      - "20001:9090"
    # 映射普罗米修斯的配置文件，用于配置 Exporter，这里的文件应该在后面创建好，具体
    # 路径以实际为准。
    volumes:
      - /Users/owenliu/lehui/data/etcd/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    container_name: grafana
    image: grafana/grafana
    environment:
      # 配置 Grafana 的默认根 URL。
      - GF_SERVER_ROOT_URL=http://10.0.1.149:20002
      # 配置 Grafana 的默认 admin 密码。
      - GF_SECURITY_ADMIN_PASSWORD=admin
    ports:
      - "20002:3000"
    # 映射 Grafana 的数据文件，方便后面进行更改。
    volumes:
      - /Users/owenliu/lehui/data/etcd/prometheus/grafana/data:/var/lib/grafana
```

## 配置 prometheus.yml 文件

``` yaml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

scrape_configs:
  # Prometheus 监控配置
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  # MySQL 监控配置
  - job_name: 'etcd'
    # 抓取间隔
    scrape_interval: 5s
    static_configs:
      # 这里配置的是具体的 MySQL Exporter 的地址，在之前的 docker compose 文件
      # 定义当中，mysql exporter 的容器名为 mysql-exporter-dev。
      - targets: ['10.0.1.149:2379']
```

## 配置 grafana 数据源

使用 `docker-compose up -d` 启动容器之后，过一会我们就可以通过访问`http://10.0.1.149:20002` 来访问 grafana 服务页面了，我们在配置 docker-compose.yml 文件中配置了环境变量 `GF_SECURITY_ADMIN_PASSWORD=admin`, 所以 grafana 的默认登陆名和密码均为 admin。

### 配置数据源

**选择 Data Sources**
![2019-04-29-11-14-21](/images/2019-04-29-11-14-21.png)

**选择 Prometheus**
![2019-04-29-11-15-37](/images/2019-04-29-11-15-37.png)

**填入 Prometheus 的 URL**
填入 Prometheus 的 URL + 端口，点击 Save & Test，这里一定要注意数据源的名字叫做 Prometheus，不然等会儿导入我的面板是无法使用的。
![2019-04-29-11-17-08](/images/2019-04-29-11-17-08.png)

### 配置 etcd dashboard

**点击 import**
![2019-04-29-11-21-33](/images/2019-04-29-11-21-33.png)

我是用的是 [etcd 的简洁 dashboard](https://grafana.com/dashboards/9618) 模版
![2019-04-29-11-23-29](/images/2019-04-29-11-23-29.png)

**导入成功保存即可**
由于我之前已经导入过一次了，所以下图中会报告已存在
![2019-04-29-11-24-26](/images/2019-04-29-11-24-26.png)

**看效果图**
![2019-04-29-11-25-54](/images/2019-04-29-11-25-54.png)

参考链接：

- [使用 Docker 部署 Grafana + Prometheus 监控 MySQL 数据库](https://www.cnblogs.com/myzony/p/10253986.html)
- [etcd 的简洁 dashboard](https://grafana.com/dashboards/9618)
- [etcd 监控指南](https://bingohuang.com/etcd-monitor-guides/)