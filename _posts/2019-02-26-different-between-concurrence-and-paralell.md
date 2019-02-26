---
layout: post
title:  "并发和并行的区别 "
date:   2019-02-25 14:16:23 +0800
categories: jekyll update
Autor: "owenliu"
typora-root-url: ../../owenliu1122.github.io
---

学习多线程的时候会遇到一个名词：并发。这是属于操作系统中的词汇，需要了解并发和并行的区别，从网上搜集了几种说法帮助理解。 
一： 
并发是指一个处理器同时处理多个任务。 
并行是指多个处理器或者是多核的处理器同时处理多个不同的任务。 
并发是逻辑上的同时发生（simultaneous），而并行是物理上的同时发生。 
来个比喻：并发是一个人同时吃三个馒头，而并行是三个人同时吃三个馒头。 
二： 
并行(parallel)：指在同一时刻，有多条指令在多个处理器上同时执行。就好像两个人各拿一把铁锨在挖坑，一小时后，每人一个大坑。所以无论从微观还是从宏观来看，二者都是一起执行的。 

![bingxing_1](/images/bingxing_1.jpg)



并发(concurrency)：指在同一时刻只能有一条指令执行，但多个进程指令被快速的轮换执行，使得在宏观上具有多个进程同时执行的效果，但在微观上并不是同时执行的，只是把时间分成若干段，使多个进程快速交替的执行。这就好像两个人用同一把铁锨，轮流挖坑，一小时后，两个人各挖一个小一点的坑，要想挖两个大一点得坑，一定会用两个小时。


![bingfa_2](/images/bingfa_2.jpg)

并行在多处理器系统中存在，而并发可以在单处理器和多处理器系统中都存在，并发能够在单处理器系统中存在是因为并发是并行的假象，并行要求程序能够同时执行多个操作，而并发只是要求程序假装同时执行多个操作（每个小时间片执行一个操作，多个操作快速切换执行）。 
三： 
当有多个线程在操作时,如果系统只有一个CPU,则它根本不可能真正同时进行一个以上的线程,它只能把CPU运行时间划分成若干个时间段,再将时间段分配给各个线程执行,在一个时间段的线程代码运行时,其它线程处于挂起状态.这种方式我们称之为并发(Concurrent)。

当系统有一个以上CPU时,则线程的操作有可能非并发.当一个CPU执行一个线程时,另一个CPU可以执行另一个线程,两个线程互不抢占CPU资源,可以同时进行,这种方式我们称之为并行(Parallel)。 

![bingfa_bingxing_3](/images/bingfa_bingxing_3.jpg)