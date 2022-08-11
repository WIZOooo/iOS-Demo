//
//  AtomicThreadNotSafeViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/10.
//

#import "AtomicThreadNotSafeViewController.h"

#import <objc/runtime.h>

@interface Super: NSObject
@property (nonatomic, unsafe_unretained) int i;
@end

@implementation Super
@end

@interface Child: Super
@property (nonatomic, unsafe_unretained) int i;
@end

@implementation Child

@synthesize i;

//-(int)i{
//    return 1;
//}

+(void) test{
    IMP superSetterMethod = class_getMethodImplementation(Super.class, @selector(setI:));
    IMP childSetterMethod = class_getMethodImplementation(Child.class, @selector(setI:));
    NSLog(@" setter is Equal = %d", superSetterMethod == childSetterMethod);
    
    IMP superGetterMethod = class_getMethodImplementation(Super.class, @selector(i));
    IMP childGetterMethod = class_getMethodImplementation(Child.class, @selector(i));
    NSLog(@" getter is Equal = %d", superGetterMethod == childGetterMethod);
}
@end

@protocol SynthesizeTestProtocol <NSObject>

@property (nonatomic, copy) NSString *testStr;

@end

@interface AtomicThreadNotSafeViewController ()<SynthesizeTestProtocol>

@property (nonatomic) UIImage *nonImage;
@property (atomic) UIImage *atomicImage;
@property (atomic, assign)NSInteger slice;

@property (nonatomic, readonly, assign)NSInteger readOnlyP;

@end

@implementation AtomicThreadNotSafeViewController

@synthesize nonImage = _nonImage;
@synthesize atomicImage = _atomicImage;
@synthesize readOnlyP = _readOnlyP;
@synthesize testStr = _testStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 线程安全的本意是再多线程的情况下，设计一套机制来保证数据读取正确。
//    // 所以虽然slice是atomic，但是只是能保证不会在同一时刻被读写，仅此而已。
//    // 假设我们在多线程的环境下对变量累加，即时加上atomic，最后变量也不是我们的期望值，而是一个随机值
//    self.slice = 0;
//    dispatch_queue_t queue = dispatch_queue_create("TestQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        for (int i=0; i<100; i++) {
//            dispatch_async(queue, ^{
//                self.slice = self.slice + 1;
//                NSLog(@"slice: %ld, thread:%@", self.slice, [NSThread currentThread]);
//            });
//        }
//    });
    
    _readOnlyP = 10;
    
    _testStr = @"23123";
    
    [Child test];
    
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

-(NSInteger)readOnlyP {
    return _readOnlyP;
}

@end
