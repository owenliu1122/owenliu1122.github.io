---
layout: post
title:  "docker-kafka部署"
date:   2019-04-02 11:24:23 +0800
categories: Kafka
tags: 
  - docker-compose
  - kafka
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---
在此记录使用 docker-compose 启动一个 kafka 集群的命令

## docker-kafka 部署
docker-compose.yml
``` yaml
version: '2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    ports:
      - "9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 10.0.1.149
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  kafka-manager:
    image: sheepkiller/kafka-manager                ## 镜像：开源的web管理kafka集群的界面
    environment:
        ZK_HOSTS: 10.0.1.149:2181                   ## 修改:宿主机IP
    ports:
      - "9000:9000"                                 ## 暴露端口
```
测试连通性
``` shell
docker exec -it kafka_kafka_1 /bin/bash
```

- 创建 topic
``` shell
$KAFKA_HOME/bin/kafka-topics.sh --create --topic test --zookeeper kafka_zookeeper_1:2181 --replication-factor 1 --partitions 1
```
- 查看 topic
``` shell
$KAFKA_HOME/bin/kafka-topics.sh --zookeeper kafka_zookeeper_1:2181 --describe --topic test
```

- 启动 producer
``` shell
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=test --broker-list kafka_kafka_1:9092
```

- 启动 consumer
``` shell
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server kafka_kafka_1:9092 --from-beginning --topic test
```