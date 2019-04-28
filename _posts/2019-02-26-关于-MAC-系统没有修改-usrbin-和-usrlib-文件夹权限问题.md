---
layout: post
title:  "[转]关于 MAC 系统没有修改 /usr/bin 和 /usr/lib 文件夹权限问题"
date:   2019-02-25 14:16:23 +0800
categories: Mac
tags: 
  - Mac
Autor: "owenliu"
---

因为 os 系统启用了 SIP ( System Intergerity Protection )  导致 root 用户也没有修改权限，所以我们需要屏蔽掉这个功能，具体做法如下：

（1）重启电脑

（2） command + R 进入 recover 模式

（3）点击最上方的菜单使用弓箭，选择终端

（4）运行命令 csrutil disable

（5）当出现 successfully 字样代表成功，重启电脑就可以了。

> 如果后面需要重新开启这个 SIP 功能，做法类似，就是在第四步的命令是 csrutil enable。

原文：<https://blog.csdn.net/gochenguowei/article/details/81152341>
版权声明：本文为博主原创文章，转载请附上博文链接！