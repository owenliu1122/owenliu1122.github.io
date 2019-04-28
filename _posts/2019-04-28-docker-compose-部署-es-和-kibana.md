---
layout: post
title: docker-compose 部署 es 和 kibana
date: 2019-04-28 19:44:34 +0800
categories: elasticsearch
tags: [elasticsearch, docker-compose, kibana]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

使用 docker-compose 部署 es 和 kibana 的配置

## docker-compose.yml

``` yaml
version: '2.2'
services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.0.0
    container_name: es01
    environment:
      - node.name=es01
      - discovery.seed_hosts=es02
      - cluster.initial_master_nodes=es01,es02
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    networks:
      - esnet
  es02:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.0.0
    container_name: es02
    environment:
      - node.name=es02
      - discovery.seed_hosts=es01
      - cluster.initial_master_nodes=es01,es02
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata02:/usr/share/elasticsearch/data
    networks:
      - esnet
  kibana:
    image: docker.elastic.co/kibana/kibana:7.0.0
    ports:
      - 5601:5601
    environment:
      SERVER_NAME: kibana
      ELASTICSEARCH_HOSTS: http://10.0.1.149:9200
    depends_on:
      - es01
      - es02

volumes:
  esdata01:
    driver: local
  esdata02:
    driver: local

networks:
  esnet:
```

⚠️：这里 elasticsearch 和 kibana 的版本号一定要是一样的，不然容器起不来，会报错的，详情请[点击这里](https://github.com/elastic/kibana#version-compatibility-with-elasticsearch)

> Ideally, you should be running Elasticsearch and Kibana with matching version numbers. If your Elasticsearch has an older version number or a newer *major* number than Kibana, then Kibana will fail to run. If Elasticsearch has a newer minor or patch number than Kibana, then the Kibana Server will log a warning.
>
> *Note: The version numbers below are only examples, meant to illustrate the relationships between different types of version numbers.*
>
> | Situation                 | Example Kibana version | Example ES version | Outcome          |
> | ------------------------- | ---------------------- | ------------------ | ---------------- |
> | Versions are the same.    | 5.1.2                  | 5.1.2              | 💚 OK             |
> | ES patch number is newer. | 5.1.**2**              | 5.1.**5**          | ⚠️ Logged warning |
> | ES minor number is newer. | 5.**1**.2              | 5.**5**.0          | ⚠️ Logged warning |
> | ES major number is newer. | **5**.1.2              | **6**.0.0          | 🚫 Fatal error    |
> | ES patch number is older. | 5.1.**2**              | 5.1.**0**          | ⚠️ Logged warning |
> | ES minor number is older. | 5.**1**.2              | 5.**0**.0          | 🚫 Fatal error    |
> | ES major number is older. | **5**.1.2              | **4**.0.0          | 🚫 Fatal error    |

参考链接：

- [kibana GitHub](https://github.com/elastic/kibana)
- [kibana 配置文档v7.0.0](https://www.elastic.co/guide/en/kibana/current/settings.html)
- [kibana 配置文档2](https://www.elastic.co/guide/cn/kibana/current/docker.html)
- [elasticsearch GitHub](https://github.com/elastic/elasticsearch)