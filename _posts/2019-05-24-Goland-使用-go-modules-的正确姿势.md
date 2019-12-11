---
layout: post
title: "Goland 使用 go modules 的正确姿势"
date: 2019-05-24 11:58:36 +0800
categories: Golang
tags: [goland, go modules]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

go modules 和 GOPATH 是互斥的, goland 如果设置了 GOPATH 就不能使用 go module

否则会报以下错误信息

```bash
$ go mod vendor
go: modules disabled inside GOPATH/src by GO111MODULE=auto; see 'go help modules'
```

并且也不支持 go get pkg@vx.x.x 的形式, 只能使用 go get pkg, 而不能指定版本信息,否则会报一下错误信息

```bash
$ go get github.com/bsm/sarama-cluster@v1.0.0  
go get: warning: modules disabled by GO111MODULE=auto in GOPATH/src;
        ignoring go.mod;
        see 'go help modules'
go: cannot use path@version syntax in GOPATH mode
```

所以只有关闭 GOPATH 才能使用 go module,**关闭 GOPATH** 就是当前所处的目录不在 GOPATH 目录下即可, 可以不设置 GOAPTH 也可以把 GOPATH 设置到一个外部目录专门作为缓存包的路径,这样 go module 的目录即为 `$GOAPTH/` 但是我认为最好是使用默认的 go modules 路径是 `~/go`, 而如果设置了 GOPATH

### 关于 GO111MODULE 环境变量

- 默认 GO111MODULE = auto 在 GOPATH 路径下会从 GOPATH 或者 vendor 中寻找依赖包,在外部会使用 go module 的方式寻找依赖包

- GO111MODULE = on 只会使用 go module 的方式寻找依赖包
   这里我们设置GO111MODULE 为on 并且在gopath路径外创建一个工程

参考文章:

[再探go modules：使用与细节](https://www.cnblogs.com/apocelipes/p/10295096.html)
