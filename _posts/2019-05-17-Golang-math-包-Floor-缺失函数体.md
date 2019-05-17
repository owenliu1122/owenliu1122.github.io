---
layout: post
title: "Golang math 包 Floor 缺失函数体"
date: 2019-05-17 19:22:36 +0800
categories: Golang
tags: [function, golang]
typora-root-url: ../../owenliu1122.github.io
typora-copy-images-to: ../images
---

偶然间，想测测 math 包下的一些函数，发现 math 包中的导出函数没有函数体，我照着这个代码，在我自己的 .go 文件中报错`missing function body`.

**代码长这样：**

``` golang
// Trunc returns the integer value of x.
//
// Special cases are:
//    Trunc(±0) = ±0
//    Trunc(±Inf) = ±Inf
//    Trunc(NaN) = NaN
func Trunc(x float64) float64

func trunc(x float64) float64 {
    if x == 0 || IsNaN(x) || IsInf(x, 0) {
        return x
    }
    d, _ := Modf(x)
    return d
}
```

**两个疑问：**

1. `func Trunc(x float64) float64`这种写法是啥东西，哪来的语法，来源是啥
2. 下面的已经实现了的未导出函数`func trunc(x float64) float64 {...}` 和这个函数什么关系

## 啥东西

首先说明这是啥东西，其实这是一个函数声明，真正的函数主体是汇编实现的，如果查看源码，这个函数出自 math 包下的 floor.go 文件，这个文件所在文件夹会有以下这些文件：

``` bash
floor_386.s
floor_amd64.s
floor_amd64p32.s
floor_arm.s
floor_arm64.s
floor_ppc64x.s
floor_s390x.s
floor_wasm.s
```

floor.go 中的函数声明都是在汇编文件内实现的

语法来源是参考 [golang spec](https://golang.org/ref/spec#Function_declarations)，原理就是

>A function declaration may omit the body. Such a declaration provides the signature for a  》 function implemented outside Go, such as an assembly routine.
>
> ```bash
> func min(x int, y int) int {
> if x < y {
>    return x
>    }
>    return y
>}
>
> func flushICache(begin, end uintptr)  // implemented externally
> ```

大意就是：函数声明可以省略正文。这样的声明是为了在 Go 之外实现这个函数提供了签名，例如汇编程序。

## 关联

`func trunc(x float64) float64 {...}` 有和这个声明有什么关系呢？

根据参考链接解释，这是 golang 的一个备用实现，比如 floor_arm.s 中实现 Trunc 的时候反而调用的是 golang 的实现，也可以用作参考和测试。

floor_arm.s

``` assembly
#include "textflag.h"

TEXT ·Floor(SB),NOSPLIT,$0
    B    ·floor(SB)

TEXT ·Ceil(SB),NOSPLIT,$0
    B    ·ceil(SB)

TEXT ·Trunc(SB),NOSPLIT,$0
    B    ·trunc(SB)
```

这里的 `.trunc` 等就是调用的 golang 实现的

参考链接：

[Bodiless function in Golang](https://stackoverflow.com/questions/29285129/bodiless-function-in-golang)

[golang spec - function declarations](https://golang.org/ref/spec#Function_declarations)