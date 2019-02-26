---
layout: post
title:  "博客使用注意事项"
date:   2019-02-25 14:16:23 +0800
categories: MyBlog
tags: 
  - github pages
  - specification
Autor: "owenliu"
---

# 博客使用注意事项

博客项目搭建参考 [Github 官方文档](https://help.github.com/en/articles/setting-up-your-github-pages-site-locally-with-jekyll)

博客编写需要遵循 jekyll 的规范，请参考 [jekyll 官网文档](https://jekyllrb.com/)  


## **创建文章**

博客的项目目录为 `owenliu1122.github.io`,

发布博客数据文件到 `_post` 目录下即可

⚠️ **注意**：文件名假定为2019-02-26-hello-world.html。(注意，文件名必须为 **"年-月-日-文章标题.后缀名"** 的格式。如果网页代码采用 html 格式，后缀名为html；如果采用 [markdown](http://daringfireball.net/projects/markdown/) 格式，后缀名为md。）

## 上传图片

如果图片放在 `_post` 目录下，当项目 build 之后，图片是没办法正确显示的，例如会报如下错误：

```
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

   ```
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

   



