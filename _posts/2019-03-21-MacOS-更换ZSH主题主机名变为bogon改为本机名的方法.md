---
layout: post
title:  "MacOS 更换ZSH主题主机名变成bogon改为本机名的方法"
date:   2019-03-21 11:24:23 +0800
categories: Mac
tags: 
  - zsh
  - terminal
  - gobon
  - hostname
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

更换了 zsh 的主题之后，主机名居然变成了 bogon，强迫症作祟，最后找到以下解决方案：

* 现象 *
  
``` shell
owenliu@bogon [11时07分25秒] [~]
-> %
```

* 操作步骤 *

``` shell
sudo hostname OwenLiu-MacBookPro
sudo scutil --set LocalHostName $(hostname)
sudo scutil --set HostName $(hostname)
```

* 结果 *

``` shell
owenliu@OwenLiu-MacBookPro [11时27分29秒] [~]
-> %
```