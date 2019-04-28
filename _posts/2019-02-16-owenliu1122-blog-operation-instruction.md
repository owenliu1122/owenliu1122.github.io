---
layout: post
title:  "博客使用注意事项"
date:   2019-02-25 14:16:23 +0800
categories: Blog
tags: 
  - Github Pages
  - Jekyll
Autor: "owenliu"
---

在 github.io 上搭建自己的博客操作笔记和遇到的一些问题

# 博客使用注意事项

博客项目搭建参考 [Github 官方文档](https://help.github.com/en/articles/setting-up-your-github-pages-site-locally-with-jekyll)

博客编写需要遵循 jekyll 的规范，请参考 [jekyll 官网文档](https://jekyllrb.com/)  

## **创建文章**

博客的项目目录为 `owenliu1122.github.io`,

发布博客数据文件到 `_post` 目录下即可

⚠️ **注意**：文件名假定为2019-02-26-hello-world.html。(注意，文件名必须为 **"年-月-日-文章标题.后缀名"** 的格式。如果网页代码采用 html 格式，后缀名为html；如果采用 [markdown](http://daringfireball.net/projects/markdown/) 格式，后缀名为md。）

## 上传图片

如果图片放在 `_post` 目录下，当项目 build 之后，图片是没办法正确显示的，例如会报如下错误：

``` shell
[2019-02-26 16:25:41] ERROR `/images/bingxing_1.jpg' not found.
[2019-02-26 16:25:41] ERROR `/jekyll/update/2019/02/25/bingfa_2.jpg' not found.
[2019-02-26 16:25:41] ERROR `/jekyll/update/2019/02/25/bingfa_bingxing_3.jpg' not found.
[2019-02-26 16:25:44] ERROR `/images/bingxing_1.jpg' not found.
[2019-02-26 16:25:44] ERROR `/jekyll/update/2019/02/25/bingfa_2.jpg' not found.
[2019-02-26 16:25:44] ERROR `/jekyll/update/2019/02/25/bingfa_bingxing_3.jpg' not found.
```

所以这里需要使用项目下的绝对路径的方式解决这个问题，

1. 首先在项目的跟路径下创建目录 `images`:

    ``` shell
    mkdir images
    ```

2. 然后把资源图片放到 `images`  目录下

    ``` shell
    cd images
    mv ../_post/*.jpg ./
    ```

3. 写博客时直接引用绝对链接

   ``` shell
   ... which is shown in the screenshot below:
   ![My helpful screenshot](/assets/screenshot.jpg)
   ```

4. 此步骤非绝对：作者写博客时在本地使用编辑器（本人为 Typora）需要在 yaml 说明头中添加 `typora-root-url: ../../owenliu1122.github.io`

   例如：

   ``` yaml
   ---
   layout: post
   title:  "并发和并行的区别 "
   Autor: "owenliu"
   typora-root-url: ../../owenliu1122.github.io
   ---
   ```

## 本地测试环境不支持中文文件名

刚刚接触 github pages，在 Mac 上安装了 Ruby，环境后，使用 jekyll 搭建博客时候，在本地预览时候无法打开，报以下错误信息：

``` shell
ERROR Encoding::CompatibilityError: incompatible character encodings: UTF-8 and ASCII-8BIT
```

或者

``` shell
ERROR -- : fsevent: running worker failed: incompatible character encodings: ASCII-8BIT and UTF-8
```

而提交到 github 上却可以正常解析。看了一下发现是文件写的博客有什么变化，原来是因为博客的 [markdown](https://www.baidu.com/s?wd=markdown&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)文件使用了中文文件名，jekyll 无法正常解析，所以才出现乱码。

解决方案有两种：

1. **修改 Ruby 的 lib 文件【[转自](http://blog.chiyiw.com/2016/03/20/jekyll-%E6%9C%AC%E5%9C%B0%E8%B0%83%E8%AF%95%E6%96%87%E4%BB%B6%E5%90%8D%E4%B8%AD%E6%96%87%E9%94%99%E8%AF%AF%E8%A7%A3%E5%86%B3.html)】**

   /System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/ruby/2.3.0/webrick/httpservlet/`  下的 filehandler.rb 文件，先备份.

   找到下列两处，添加一句（`+`的一行为添加部分）

   ``` ruby
   path = req.path_info.dup.force_encoding(Encoding.find("filesystem"))+ path.force_encoding("UTF-8") # 加入编码if trailing_pathsep?(req.path_info)
   ```

   ``` ruby
   break if base == "/"+ base.force_encoding("UTF-8") #加入編碼break unless File.directory?(File.expand_path(res.filename + base))
   ```

> 修改完重新`jekyll serve`即可支持中文文件名。

⚠️注意：这里修改库文件有可能失败，解决方案参考[这里](https://owenliu1122.github.io/mac/2019/02/25/%E5%85%B3%E4%BA%8E-MAC-%E7%B3%BB%E7%BB%9F%E6%B2%A1%E6%9C%89%E4%BF%AE%E6%94%B9-usrbin-%E5%92%8C-usrlib-%E6%96%87%E4%BB%B6%E5%A4%B9%E6%9D%83%E9%99%90%E9%97%AE%E9%A2%98/)

2. **基于 Docker 搭建本地 jykell 环境【[转自](https://archerwq.github.io/2017/09/21/setup-jekyll-locally-with-docker/)】**

   在本地安装 Jekyll 虽然不是很复杂，但对于不懂 Ruby 的小白用户来说，安装 Ruby, RubyGems, GCC&Make 也不是很轻松，还好有 Docker，可以一键 Setup.

   **安装Docker**

   参考：[Install Docker](https://docs.docker.com/engine/installation/)，[docker compose](https://docs.docker.com/compose/reference/overview/)

   **创建docker-compose.yml**

   ``` yaml
   jekyll:
       image: jekyll/jekyll:pages
       command: jekyll serve --watch
       ports:
           - 3999:4000
       volumes:
           - ~/dev/git/archerwq.github.io:/srv/jekyll/
   ```

    - **jekyll/jekyll: pages** 是专门适用于 Github Pages 的 Jekyll 镜像

    - **jekyll serve –watch**: 启动容器时运行的命令，这个命令会启动 Jekyll 内置的用于开发环境的 Web 服务器，**–watch **参数表示有任何文件变化时自动重新生成网页

    - **3999:4000**: 把容器的 4000 端口映射到宿主机的 3999 端口

    - **xxxxx/owenliu1122.github.io:/srv/jekyll/** 把宿主机上的 Jekyll Site 所在目录映射到容器的**/srv/jekyll/**目录，Jekyll 默认从这个目录读 Jekyll Site

    **启动 Docker 容器**

      在 docker-compose.yml 所在目录运行 **docker-compose up** 命令， 如下:

      ```shell
   ➜  github.io docker-compose -f docker-compose.yml up -d
   Pulling jekyll (jekyll/jekyll:pages)...
   pages: Pulling from jekyll/jekyll
   6c40cc604d8e: Pull complete
   4e0e4ac8c025: Pull complete
   9a13ad0cfe1d: Pull complete
   16f42435de28: Pull complete
   6b537e0b3f4d: Pull complete
   Creating githubio_jekyll_1 ... done
      ```

      这样你就可以在本地编辑文章，然后通过访问 `http://localhost:3999` 动态的看到文章的显示效果。

### 修改默认主题有两种方式

1. 在_layouts目录添加自己的主题，还包括_includes/_sass/assets
2. 修改Gemfile来加载现成的第三方主题，有点像CocoaPods

打开Gemfile

``` shell
gem "github-pages", group: :jekyll_plugins
```

然后更新Gemfile配置

``` shell
$ bundle update
bundle update
The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
Fetching gem metadata from https://rubygems.org/..........
Fetching version metadata from https://rubygems.org/..
...
Using jekyll-theme-primer 0.5.0
Using jekyll-theme-slate 0.1.0
Using jekyll-theme-tactile 0.1.0
Using jekyll-theme-time-machine 0.1.0
Using github-pages 155
Bundle updated!
```

看一下我们都下载那些主题，这些主题和GitHub官网推荐的主题是一样的

``` shell
$ gem list jekyll-theme

*** LOCAL GEMS ***

jekyll-theme-architect (0.1.0)
jekyll-theme-cayman (0.1.0)
jekyll-theme-dinky (0.1.0)
jekyll-theme-hacker (0.1.0)
jekyll-theme-leap-day (0.1.0)
jekyll-theme-merlot (0.1.0)
jekyll-theme-midnight (0.1.0)
jekyll-theme-minimal (0.1.0)
jekyll-theme-modernist (0.1.0)
jekyll-theme-primer (0.5.1, 0.5.0)
jekyll-theme-slate (0.1.0)
jekyll-theme-tactile (0.1.0)
jekyll-theme-time-machine (0.1.0)
```

我们只要修改_config.yml里面的主题字段就可以使用了 theme: jekyll-theme-minimal

另外还有很多现成的第三方主题，可以在<https://rubygems.org/>搜索”jekyll theme”看到

gem uninstall listen gem install listen bundle