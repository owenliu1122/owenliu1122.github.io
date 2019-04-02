---
layout: post
title:  "VSCode-Markdown图片复制插件路径配置"
date:   2019-03-21 12:05:23 +0800
categories: VSCode
tags: 
  - upload
  - image
  - copy
  - default path
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

以下两种插件使用可以任选一种，我个人比较喜欢 Paste Image，方便一些

## Markdow Preview Enhanced
在使用 markdown-preview-enhance 这个插件的 image helper 功能来上传文件时候，在本地文件复制时候，这个插件的默认 copy 路径是当前打开文件夹下的 /assets 目录下，而我的需求是使用这个插件插入本地图片时候，把我插入的图片复制到当前 VSCode 打开文件夹下的 /images 文件夹下。

配置过程见下图：

![markdown-preview-enhanced-image-path-config](/images/markdown-preview-enhanced-image-path-config.png)


参考连接：
- [markdown-preview-enhanced官方手册](https://shd101wyy.github.io/markdown-preview-enhanced/#/zh-cn/)
- https://www.worthfo.com/p/870354/


## Paste Image
这个官方文档介绍比较全面了，这里简单介绍几个关键点

- Paste Image: Path 这个设置的是粘贴文件时复制的目标目录
![2019-03-21-13-11-27](/images/2019-03-21-13-11-27.png)

- Paste Image: Base Path 这个设置会影响到粘贴文件时候 `(/image/xxxx.png)` 路径的粘贴, 不然会显示 `(../images/xxxx.png)`
![2019-03-21-13-06-04](/images/2019-03-21-13-06-04.png)

- Pates Image: Insert Pattern 这个设置是可以填充 `![xxxx]()` 的 xxxx 部分，不然默认为空
![2019-03-21-13-08-12](/images/2019-03-21-13-08-12.png)

- Paste Image Prefix 这个是图片路径的前缀， 不然图片路径为 `![](images/xxxx.png)`, 设置这个就是 `![](/images/xxxx.png)`
![2019-03-21-13-09-09](/images/2019-03-21-13-09-09.png)

参考链接：
- [Gihub 地址](https://github.com/mushanshitiancai/vscode-paste-image)
- [Paste Image 官方文档](https://marketplace.visualstudio.com/items?itemName=mushan.vscode-paste-image)


