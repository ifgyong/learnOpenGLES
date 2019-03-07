//
//  ViewController.m
//  FYThreadDemo
//
//  Created by Charlie on 2019/3/7.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//
/*
同步+并行  =  不创建新线程 串行执行 <NSThread: 0x600001f58d00>{number = 1, name = main}
异步+并行  =  创建新线程 并发执行 <NSThread: 0x600001f02880>{number = 3, name = (null)}
异步+串行  =  创建新线程 并发执行 <NSThread: 0x600001f34440>{number = 4, name = (null)}
同步+串行  =  不创建新线程 串行执行 <NSThread: 0x600001f58d00>{number = 1, name = main}
异步+主队列=  不创建新线程 并行执行 <NSThread: 0x600001f58d00>{number = 1, name = main}
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self async1];
    [self async2];
    [self sync1];
    [self sync2];
    [self main_queue1];
//    [self main_queue2];
}
- (void)async1{
    dispatch_queue_t queue= dispatch_queue_create("com.demo.create", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"异步+并行=  创建新线程 并发执行 %@",[[NSThread currentThread] description]);
    });
}
- (void)async2{
    dispatch_queue_t queue= dispatch_queue_create("com.demo.create", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"异步+串行=  创建新线程 并发执行 %@",[[NSThread currentThread] description]);
    });
}
- (void)sync1{
    dispatch_queue_t queue= dispatch_queue_create("com.demo.create", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"同步+并行=  不创建新线程 串行执行 %@",[[NSThread currentThread] description]);
    });
}
- (void)sync2{
    dispatch_queue_t queue= dispatch_queue_create("com.demo.create", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"同步+串行=  不创建新线程 串行执行 %@",[[NSThread currentThread] description]);
    });
}

- (void)main_queue1{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"异步+主队列=  不创建新线程 并行执行 %@",[[NSThread currentThread] description]);
    });
}
- (void)main_queue2{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"同步步+主队列 = 死锁 %@",[[NSThread currentThread] description]);
    });
}
@end
