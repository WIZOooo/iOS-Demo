//
//  MultiThreadViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/10.
//

#import "MultiThreadViewController.h"

@interface MultiThreadViewController ()

@end

@implementation MultiThreadViewController

/*
 可以把队列看成是处理机构，机构中的角色都有两个，处理人和分配人。
 串行队列是机构中只有一个人身兼两职
 并行队列是机构中有很多处理人,还有一个分配人。
 
 任务可以看成是带有字条的办事者，字条就是任务的具体内容，
 同步任务是分配人必需把办事者的纸条念完才能处理别的办事者，
 异步任务是可以让分配人先登记，稍后处理人再念字条的内容
 
 当串行队列遇到同步任务，处理兼职分配人直接念字条，先进先出
 当串行队列遇到异步任务，处理兼职分配人登记，先进先出，处理兼职分配人念字条，先进先出
 
 当并发队列遇到同步任务，分配人直接念字条，先进先出
 当并发队列遇到异步任务，分配人登记给不同处理人，各个处理人同时执行
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"主线程 %@",[NSThread currentThread]);
    
    [self serialQueueTest];
    
//    [self conCurrentQueueTest];
}

- (void)addSyncTask:(dispatch_queue_t)queue {
    for(int i = 0; i < 5; i++){
        dispatch_sync(queue, ^{
            NSLog(@"我开始了：%@ , %@",@(i),[NSThread currentThread]);
            [NSThread sleepForTimeInterval: i % 3];
            NSLog(@"执行完成：%@ , %@",@(i),[NSThread currentThread]);
        });
    }
}

- (void)addAsyncTask:(dispatch_queue_t)queue {
    for(int i = 0; i < 5; i++){
        dispatch_async(queue, ^{
            NSLog(@"我开始了：%@ , %@",@(i),[NSThread currentThread]);
            [NSThread sleepForTimeInterval: i % 3];
            NSLog(@"执行完成：%@ , %@",@(i),[NSThread currentThread]);
        });
    }
}

-(void) serialQueueTest {
    /// 创建串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("Dan-serial", DISPATCH_QUEUE_SERIAL);
    
    // 添加同步任务，结果是在主线程执行，顺序执行任务
//    [self addSyncTask:serialQueue];
    
    // 添加异步任务，结果是开启了新线程，顺序执行任务
    [self addAsyncTask:serialQueue];
}

-(void) conCurrentQueueTest {
    ///创建并发队列
    dispatch_queue_t concurrent_queue = dispatch_queue_create("DanCONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务，结果是开启了新线程，乱序执行任务
    [self addAsyncTask:concurrent_queue];
    
    // 添加同步任务，结果是主线程执行，顺序执行任务
//    [self addSyncTask:concurrent_queue];
}

@end
