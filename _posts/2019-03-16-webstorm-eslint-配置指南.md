---
layout: post
title:  "webstorm eslint 配置指南"
date:   2019-03-16 13:05:23 +0800
categories: Javascript
tags: 
  - WebStorm
  - ESLint
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

WebStorm 配置 ESLint

## 开启项目 ESLint 

Preference -> Languages & Frameworks -> JavaScript -> Code Quality Tools -> ESLint

勾选 Enable

![image-20190316131002112](/images/image-20190316131002112.png)

此处确认是否勾选了其他的代码验证，可自行配置，ESLint 这个必须勾选。

![1847986-571ca359b2674673](/images/1847986-571ca359b2674673.png)



## 快捷键修复光标所在行的格式问题

⌥  + ⏎（opt + enter ）然后会出现菜单列表，可以根据需要选择选项。

例如：

1. 修复组件属性排序

   ![image-20190316133548853](/images/image-20190316133548853.png)

2. 修复文件内的格式错误

   ![image-20190316134427590](/images/image-20190316134427590.png)

3. Fix ESLint Problemes

   修复 ESLint 报告出来的所有错误 ，也可在 Keymap 中设置快捷键

   ![image-20190316134616597](/images/image-20190316134616597.png)