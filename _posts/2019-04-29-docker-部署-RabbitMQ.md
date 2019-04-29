---
layout: post
title: docker 部署 RabbitMQ
date: 2019-04-29 12:12:45 +0800
categories: RabbitMQ
tags: [docker, rabbitmq]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
description: docker 一键部署本地 RabbitMQ 测试环境
---

```shell
docker pull rabbitmq:management

docker run -d -p 5672:5672 -p 15672:15672 --name rabbitmq rabbitmq:management
```

浏览器：localhost:15672

默认用户密码：guest， guest