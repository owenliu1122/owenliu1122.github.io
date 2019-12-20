---
layout: post
title: Postman Visualize 自定义响应渲染显示
date: 2019-12-20 13:21:23 +0800
category: Javascript
tags:
- postman
- visualize
- response
- handlebars
- qrcode
typora-root-url: ../
typora-copy-image-to: ../images
---

在使用 postman 测试接口的过程中，发现了它的 [visualize](https://learning.getpostman.com/docs/postman/sending-api-requests/visualizer/) 功能正好帮助我解决了我一下两点需求.
- 响应体需要根据特殊的拦截条件向内注入一些附加信息，方便后续处理和显示，这里是扩展了一些 json 字段，然后将 json 代码渲染出来，这种场景也可以支持更多的语言显示，比如 golang，java，nginx，C/C++ 等语言，我这里用的是 [prism](https://prismjs.com/index.htm)
- 测试时，响应体返回 URL，并且测试者需要将 URL 转换成二维码，并显示到屏幕，以便于做测试，如果没有这个解决方案，我的测试方法是每次都复制出来，用二维码生成器手动生成再扫码测试。

### 高亮显示 JSON 数据

``` javascript
let jsonData = pm.response.json()

jsonData = {
    "name": "liujiaxing",
    "age": 18,
    "weight": 150,
}

var template = `
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/themes/prism-twilight.css">
    <pre class="line-numbers"><code class="language-json">{{response}}</code></pre>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/prism.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-json.js"></script>
`;

pm.visualizer.set(template, {
    response: JSON.stringify(jsonData, null, 4)
});
```

![image-20191220140352925](/images/image-20191220140352925.png)

## 显示二维码

``` javascript
let jsonData = pm.response.json()
console.log("url:", jsonData["url"])
jsonData["raw"] = JSON.stringify(jsonData, null, 4)

var template = `
   <style type="text/css">
		.qrcodebox {
			font-size: 14px;
			color: #333333;
			width: 100%;
			border-width: 1px;
			border-color: #87ceeb;
			border-collapse: collapse;
			background-color: transparent;
			padding: 16px 0
		}
		#qrcodeCanvas{
			width: 260px;
			height: 260px;
			margin: 8px auto;
 			background-color: #fff;
			display: flex;
			justify-content: center;
			align-items: center;
		}
	</style>

	<script src="https://libs.baidu.com/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdn.bootcss.com/jquery.qrcode/1.0/jquery.qrcode.min.js"></script>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/themes/prism-okaidia.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/prism.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-json.js"></script>

	<div class="qrcodebox">
		<div id="qrcodeCanvas"></div>
	</div>
	
	<pre class="line-numbers"><code class="language-json">{{response.raw}}</code></pre>
   
    <script>
    	jQuery('#qrcodeCanvas').qrcode({
    	    frontclolor: "blue",
    	    width: 222,
    		height: 222,
    		text: "{{{response.url}}}"
    	});	
    </script>
`;

pm.visualizer.set(template, {
    response: jsonData
});
```

参考链接：

- <https://learning.getpostman.com/docs/postman/sending-api-requests/visualizer/>
- <https://prismjs.com/index.htm>
- <https://prismjs.com/examples.htmll>
- <https://cdnjs.com/libraries/prism>
- <https://github.com/cdnjs/cdnjs>
- <https://handlebarsjs.com/guide/hooks.html#helpermissing>
- <https://www.cnblogs.com/pellime/p/9949843.html>
- <http://jeromeetienne.github.io/jquery-qrcode/>