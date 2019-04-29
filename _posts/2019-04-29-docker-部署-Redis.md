---
layout: post
title: docker 部署 Redis
date: 2019-04-29 12:15:11 +0800
categories: Redis
tags: [docker, redis]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---



``` shell
docker pull  redis:5.0

cd /Users/owenliu/lehui/data/redis_data

docker run -p 6379:6379 -v $PWD:/data  -d redis:5.0 redis-server --appendonly yes

src/redis-cli -h localhost -p 6379
```

