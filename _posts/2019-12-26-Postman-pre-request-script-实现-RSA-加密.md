---
layout: post
title: Postman pre-request-script 实现 RSA 加密
date: 2019-12-26 14:39:39 +0800
category: Javascript
tags:
- postman
- rsa
- encrypt
typora-root-url: ../
typora-copy-image-to: ../images
---

## Postman 进行 RSA 加解密的解决办法

### 方案介绍

postman 提供了变量功能，可以将支持 RSA 加解密的代码放到变量中，然后通过`eval`加载到当前环境中来，就可以使用自定义的加解密方案了。
**下面介绍了生成`forge.js`文件的具体方式，如果想要直接使用可以前往我的github页面进行下载**

### 安装 node 和 git

安装node主要是进行打包，必须安装。
安装git主要是进行代码下载，可选，可以手动进行下载代码。

### 下载 forge 源码

```
git clone https://github.com/digitalbazaar/forge.git
cd /path/to/your/dir
npm install
```

### 修改配置

将`webpack.config.js`中的`umd`替换为`var`，现在配置文件长这样
{% raw %}
```
const bundle = Object.assign({}, common, {
    output: {
      path: path.join(__dirname, 'dist'),
      filename: info.filenameBase + '.js',
      library: info.library || '[name]',
      libraryTarget: info.libraryTarget || 'var'
    }
  });
  if(info.library === null) {
    delete bundle.output.library;
  }
  if(info.libraryTarget === null) {
    delete bundle.output.libraryTarget;
  }

  // optimized and minified bundle
  const minify = Object.assign({}, common, {
    output: {
      path: path.join(__dirname, 'dist'),
      filename: info.filenameBase + '.min.js',
      library: info.library || '[name]',
      libraryTarget: info.libraryTarget || 'var'
    },
    devtool: 'cheap-module-source-map',
    plugins: [
      new webpack.optimize.UglifyJsPlugin({
        sourceMap: true,
        compress: {
          warnings: true
        },
        output: {
          comments: false
        }
        //beautify: true
      })
    ]
  });
```
{% endraw %}
### 重新打包

```
npm run build
```

完成之后在`dist`目录下就有一个文件`forge.js`，这就是我们想要的（在我的项目页面有现成的下载）

**文件如何生成介绍完毕，下面介绍如何使用这个文件**

## 使用生成的`forge.js`进行RSA加解密

下面介绍两种办法

### 手动进行添加变量


postman提供了变量功能，所以可以在postman中手动添加一个变量`forgeJS`，值设置为`forge.js`文件中的所有内容，全选并复制粘贴进去

![postman-forgeJS-env](/images/postman-forgeJS.jpg)


然后新建一个请求，在`pre-script`中添加下面的代码


{% raw %}
```
eval(postman.getGlobalVariable("forgeJS"));

const public_key = '-----BEGIN PUBLIC KEY-----\n'+
'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDORoOSW2gbHl6s/YmS1jWxb954\n'+
'X/jflZ2dK65oM/Bxii2Iba80IiC9+Sa1phmOVDAk+IVDsPNZ+YJ2Qg0hPmoLSLxe\n'+
'f2A6ySJPl5su8TaGOuVZg1SRyk55bjHymQUnxryD/ml1EmBUaGcrs9FCiVBy38kg\n'+
'eZNbCexucVQxn6OYlwIDAQAB\n'+
'-----END PUBLIC KEY-----'

const private_key = '-----BEGIN PRIVATE KEY-----\n' +
'MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM5Gg5JbaBseXqz9\n' +
'iZLWNbFv3nhf+N+VnZ0rrmgz8HGKLYhtrzQiIL35JrWmGY5UMCT4hUOw81n5gnZC\n' +
'DSE+agtIvF5/YDrJIk+Xmy7xNoY65VmDVJHKTnluMfKZBSfGvIP+aXUSYFRoZyuz\n' +
'0UKJUHLfySB5k1sJ7G5xVDGfo5iXAgMBAAECgYEAk6KQZN4bQt2XsYS9RGUghOCm\n' +
'f81g2NXCu00aROZ3vyvArxaiAVQzzwRWGkjJnb7PvoZJC0vIwKr+HxnjP9nmFufd\n' +
'+0EnBT+imYSzrfZhfGGwyI6EIyy/XcoW5lf0xltx3w9mJicnR9kMzNtZ5mNGPMNn\n' +
'CgAgjvZqnWYb+f6tb/ECQQD0tdpg8ts3puXclPe51my+LbKhEbyFSMzvtMTDCRmO\n' +
'd0jrmZhQomsZacC8+l+2l6WTj5vrhVQlAVUeUJ7kldQNAkEA18q53wor6a4Cv0OL\n' +
'xFzBWXRCMVFfyCWAFQUpTSGrIM/X4Lx30IZCShtvkdh1ky39b9T6lpOjES7MK4Dh\n' +
'xttCMwJAUGBi6DEcm/zvxzIO5DVv5k9wOsNunoC4/4rqjf0xLcA0bV43z1RpxSEd\n' +
'M3UxdvH8aqli10slxjnX0Ws9pWspCQJBALqSncgYzETbXaauqO5a4BUOrphjafPr\n' +
'cGU8NCxrGsFg0p6NdO5G1pOqSvmHdIiPL9t8AjkkZs3Zb0+BvDOpqP8CQQDZhfh4\n' +
'/c/Qzp4szj7+GXTZ1cmGwAuFo2/9uiumUAS3f19EpgoV9u9eyJ4gZPEBDvAjO961\n' +
'kAjdja4DAy4SbCXy\n' +
'-----END PRIVATE KEY-----'

//encrypt text "plaintext"
var publicKey = forge.pki.publicKeyFromPem(public_key);
var encryptedText = forge.util.encode64(publicKey.encrypt("plaintext", 'RSA-OAEP', {
  md: forge.md.sha1.create(),
  mgf1: {
    md: forge.md.sha1.create()
  }
}));
console.log("encrypted text:" + encryptedText);

// decrypt text
var privateKey = forge.pki.privateKeyFromPem(private_key);
var decryptedText = privateKey.decrypt(forge.util.decode64(encryptedText), 'RSA-OAEP', {
  md: forge.md.sha1.create(),
  mgf1: {
    md: forge.md.sha1.create()
  }
});

console.log("dectypted text:" + decryptedText);
```
{% endraw %}


![postman-rsa-pre-request-script](/images/postman-rsa-pre-request-script-code.png)

发送请求就可以看到执行结果，这个例子是把`plaintext`先进行加密，然后进行解密打印出来，结果可以在postman的console窗口查看

![DFB404BB-DA6B-4D60-838E-AAB13930B03C](/images/DFB404BB-DA6B-4D60-838E-AAB13930B03C.png)



![5D20BF07-2B56-47EC-922B-BF36A40BBFF2](/images/5D20BF07-2B56-47EC-922B-BF36A40BBFF2.png)



### 将文件传到web服务器进行自动设置

上面的办法有点太麻烦了，而且由于文件太大，添加变量的时候会**很卡很卡**，所以可以将`forge.js`添加到web服务器（**本地的也可以，但是直接用github的链接不行**），然后跟上面步骤一样的，但是`pre-script`使用下面的代码，注意要把`http://path/to/forge.js`换成你自己的服务器的地址。

{% raw %}
```
//download forgeJS from web and set varible

if (!pm.globals.has("forgeJS")) {
    pm.sendRequest("https://raw.githubusercontent.com/loveiset/RSAForPostman/master/forge.js", function (err, res) {
        if (err) {
            console.log(err);
        } else {
            pm.globals.set("forgeJS", res.text());
        }
    })
} else {
    eval(pm.globals.get("forgeJS"))
    const public_key = '-----BEGIN PUBLIC KEY-----\n' +
        'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDORoOSW2gbHl6s/YmS1jWxb954\n' +
        'X/jflZ2dK65oM/Bxii2Iba80IiC9+Sa1phmOVDAk+IVDsPNZ+YJ2Qg0hPmoLSLxe\n' +
        'f2A6ySJPl5su8TaGOuVZg1SRyk55bjHymQUnxryD/ml1EmBUaGcrs9FCiVBy38kg\n' +
        'eZNbCexucVQxn6OYlwIDAQAB\n' +
        '-----END PUBLIC KEY-----'

    const private_key = '-----BEGIN PRIVATE KEY-----\n' +
        'MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM5Gg5JbaBseXqz9\n' +
        'iZLWNbFv3nhf+N+VnZ0rrmgz8HGKLYhtrzQiIL35JrWmGY5UMCT4hUOw81n5gnZC\n' +
        'DSE+agtIvF5/YDrJIk+Xmy7xNoY65VmDVJHKTnluMfKZBSfGvIP+aXUSYFRoZyuz\n' +
        '0UKJUHLfySB5k1sJ7G5xVDGfo5iXAgMBAAECgYEAk6KQZN4bQt2XsYS9RGUghOCm\n' +
        'f81g2NXCu00aROZ3vyvArxaiAVQzzwRWGkjJnb7PvoZJC0vIwKr+HxnjP9nmFufd\n' +
        '+0EnBT+imYSzrfZhfGGwyI6EIyy/XcoW5lf0xltx3w9mJicnR9kMzNtZ5mNGPMNn\n' +
        'CgAgjvZqnWYb+f6tb/ECQQD0tdpg8ts3puXclPe51my+LbKhEbyFSMzvtMTDCRmO\n' +
        'd0jrmZhQomsZacC8+l+2l6WTj5vrhVQlAVUeUJ7kldQNAkEA18q53wor6a4Cv0OL\n' +
        'xFzBWXRCMVFfyCWAFQUpTSGrIM/X4Lx30IZCShtvkdh1ky39b9T6lpOjES7MK4Dh\n' +
        'xttCMwJAUGBi6DEcm/zvxzIO5DVv5k9wOsNunoC4/4rqjf0xLcA0bV43z1RpxSEd\n' +
        'M3UxdvH8aqli10slxjnX0Ws9pWspCQJBALqSncgYzETbXaauqO5a4BUOrphjafPr\n' +
        'cGU8NCxrGsFg0p6NdO5G1pOqSvmHdIiPL9t8AjkkZs3Zb0+BvDOpqP8CQQDZhfh4\n' +
        '/c/Qzp4szj7+GXTZ1cmGwAuFo2/9uiumUAS3f19EpgoV9u9eyJ4gZPEBDvAjO961\n' +
        'kAjdja4DAy4SbCXy\n' +
        '-----END PRIVATE KEY-----'


    //encrypt text "plaintext"
    var publicKey = forge.pki.publicKeyFromPem(public_key);
    var encryptedText = forge.util.encode64(publicKey.encrypt("plaintext", 'RSA-OAEP', {
        md: forge.md.sha1.create(),
        mgf1: {
            md: forge.md.sha1.create()
        }
    }));
    console.log("encrypted text:" + encryptedText);

    // decrypt text
    var privateKey = forge.pki.privateKeyFromPem(private_key);
    var decryptedText = privateKey.decrypt(forge.util.decode64(encryptedText), 'RSA-OAEP', {
        md: forge.md.sha1.create(),
        mgf1: {
            md: forge.md.sha1.create()
        }
    });

    console.log("dectypted text:" + decryptedText);


}
```
{% endraw %}

好了，到这里，已经可以使用postman进行RSA的加解密了！！

## 其它事项说明

### 引用

forge 是其它开源项目，这里进行了直接的使用
项目地址：https://github.com/digitalbazaar/forge
而且关于RSA加密的相关文档同样的可以查看这个地址

### 如何删除`forgeJS`变量

相信实验过的人已经发现了，由于文件内容太大，编辑的时候会导致postman特别卡，所以我反悔了，想要删除掉这个变量怎么办。
别急，首先新增一个空白请求，url随便填一个，比如`www.baidu.com`，然后在`pre-script`中添加下面的内容

```
pm.globals.unset("forgeJS");
```

发送一下请求，这个变量就删掉了

### 其它说明

毕竟这个方式比较奇特，还是希望postman官方将RSA加密尽早加入到支持列表中。

## 项目地址

关于其他更详细的介绍以及相关的文件，可以在这个地址中查看：https://github.com/loveiset/RSAForPostman



参考链接：

- [原文链接](https://testerhome.com/topics/14869)
- <https://github.com/owenliu1122/RSAForPostman>
- <https://github.com/digitalbazaar/forge/blob/master/README.md#rsa>