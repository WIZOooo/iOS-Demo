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
 可以把队列看成是处理机构，机构中人员都有两个职能，处理和分配。
 串行队列是机构中只有一个人
 并行队列是机构中有很多人。
 
 任务可以看成是带有字条的办事者
 同步任务是工作人员人必需把办事者的纸条念完才能处理别的任务，
 异步任务是可以让工作人员先分配，然后再由其他人员或者当前人员来执行（取决于有几个人）。
 
 当串行队列遇到任何任务，工作人员直接按照任务顺序办事，
 如果任务中还有子任务，
 如果子任务是同步任务，死锁，因为队列需要执行完当前任务才能添加子任务，但是子任务的添加需要等待队列执行完当前任务。
 如果子任务是异步任务，排在队列最后执行。
 
 当并发队列遇到同步任务，工作人员直接办事
 当并发队列遇到异步任务，工作人员直接分给其他工作人员，各工作人员同时执行。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"主线程 %@",[NSThread currentThread]);
    
    [self serialQueueTestMixedTaskTest];
    
//    [self conCurrentQueueTestMixedTaskTest];
    
//    [self serialQueueTest];
    
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


// 先异步后同步
- (void)asyncAndSync:(dispatch_queue_t)queue {
    ///添加异步任务
    ///添加同步任务，同步任务执行时，异步任务中再添加异步任务
    ///查看异步任务是否执行，验证同步任务是否会阻塞队列
    
    dispatch_async(queue, ^{
        NSLog(@"异步任务执行");
        [NSThread sleepForTimeInterval: 3];
        NSLog(@"添加异步子任务");
        dispatch_async(queue, ^{
            NSLog(@"异步子任务执行");
        });
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"同步任务执行");
//        [NSThread sleepForTimeInterval: 10];
//        NSLog(@"同步任务执行完毕");
    });
}

// 先同步后异步
- (void)syncAndAsync:(dispatch_queue_t)queue {
    ///添加同步任务
    ///添加异步任务，同步任务执行时，异步任务中再添加异步任务
    ///查看异步任务是否执行，验证同步任务是否会阻塞队列
    dispatch_sync(queue, ^{
        NSLog(@"同步任务执行");
        [NSThread sleepForTimeInterval: 10];
        NSLog(@"同步任务执行完毕");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"异步任务执行");
        [NSThread sleepForTimeInterval: 3];
        NSLog(@"添加异步子任务");
        dispatch_async(queue, ^{
            NSLog(@"异步子任务执行");
        });
    });
}

// 并发队列里面的混合任务（同步+异步）
- (void)conCurrentQueueTestMixedTaskTest {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("DanCONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    ///结果是：同步任务执行中时，异步任务及其子任务均执行完毕
//    [self asyncAndSync:concurrent_queue];
    
    
    ///结果是：同步任务执行中时，异步任务及其子任务均不执行
    [self syncAndAsync:concurrent_queue];
}

- (void)serialQueueTestMixedTaskTest {
    dispatch_queue_t serialQueue = dispatch_queue_create("Dan-serial", DISPATCH_QUEUE_SERIAL);
    
    // 结果是：异步任务-同步任务-异步子异步任务
    [self asyncAndSync:serialQueue];
    
}

@end
