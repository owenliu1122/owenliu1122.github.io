---
layout: post
title:  "Golang io interface 实践笔记"
date:   2019-03-12 11:09:23 +0800
categories: Golang
tags: 
  - io
  - reader
  - writer
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

使 Reader 接口转为 ReaderCloser

```Go
ioutil.NopCloser(strings.NewReader("my message body")
```

[]byte Reader

```go
body := []byte("message body")
bytes.NewReader(body)
```

string Reader

``` go
body = "message body"
strings.NewReader(body)
```

从 Reader 复制数据到 Writer 中

``` go
reader := strings.NewReader("message body")
var writer bytes.Buffer
_, err = io.Copy(&writer, reader)
```

