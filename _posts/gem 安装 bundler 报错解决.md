---
layout: post
title:  "gem 安装 bundler 报错"
date:   2019-03-18 10:42:23 +0800
categories: Ruby
tags: 
  - gem
  - bundler
  - error
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

问题
```shell
gem install bundler
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.
```

解决
```shell
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
```

