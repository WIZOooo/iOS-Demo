//
//  AtomicThreadNotSafeViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/10.
//

#import "AtomicThreadNotSafeViewController.h"

@interface AtomicThreadNotSafeViewController ()

@property (nonatomic) UIImage *nonImage;
@property (atomic) UIImage *atomicImage;
@property (atomic, assign)NSInteger slice;
@end

@implementation AtomicThreadNotSafeViewController

@synthesize nonImage = _nonImage;
@synthesize atomicImage = _atomicImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 线程安全的本意是再多线程的情况下，设计一套机制来保证数据读取正确。
    // 所以虽然slice是atomic，但是只是能保证不会在同一时刻被读写，仅此而已。
    // 假设我们在多线程的环境下对变量累加，即时加上atomic，最后变量也不是我们的期望值，而是一个随机值
    self.slice = 0;
    dispatch_queue_t queue = dispatch_queue_create("TestQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<100; i++) {
            dispatch_async(queue, ^{
                self.slice = self.slice + 1;
                NSLog(@"slice: %ld, thread:%@", self.slice, [NSThread currentThread]);
            });
        }
    });
}

//nonatomic的setter和getter实现：
- (void)setNonImage:(UIImage *)nonImage
{
    _nonImage = nonImage;
}

- (UIImage *)nonImage
{
    return _nonImage;
}

//atomic的setter和getter实现：,本质上atomic就是加了读写锁
- (void)setAtomicImage:(UIImage *)atomicImage
{
    @synchronized (self) {
        _atomicImage = atomicImage;
    }
}

- (UIImage *)atomicImage
{
    @synchronized (self) {
        return _atomicImage;
    }
}

@end
