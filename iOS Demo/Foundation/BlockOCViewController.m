//
//  BlockOCViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/15.
//

#import "BlockOCViewController.h"

@interface Person : NSObject

@property (nonatomic, assign)NSInteger age;

@end

@implementation Person

- (instancetype)init {
    self = [super init];
    _age = 0;
    return self;
}

@end

@interface BlockOCViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void(^referenceLoopBlock)(void);

@end

@implementation BlockOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self valueCopy];
    NSLog(@"-----");
    [self dashDashBlockKeyWords];
}

// 值拷贝
- (void)valueCopy {
    NSInteger i = 1;
    void(^block)(void) = ^{
        NSLog(@"block %ld:", i);
    };
    i += 1;
    NSLog(@"index1 %ld:", i); //index1 2
    block(); // block 1
    NSLog(@"index2 %ld:", i); //index2 2
}

// 指针引用
- (void)pointerCopy {
    Person *i = [Person new];
    void(^block)(void) = ^{
        i.age += 1;
        NSLog(@"block %ld:", i.age);
    };
    i.age += 1;
    NSLog(@"index1 %ld:", i.age); //index1 2
    block(); // block 1
    NSLog(@"index2 %ld:", i.age); //index2 2
}

// __block关键字
- (void)dashDashBlockKeyWords {
    __block NSInteger i = 1;
    void(^block)(void) = ^{
        NSLog(@"block %ld:", i);
    };
    i += 1;
    NSLog(@"index1 %ld:", i); //index1 2
    block(); // block 1
    NSLog(@"index2 %ld:", i); //index2 2
}

// 循环引用
- (void)avoidLoopReference {
    
    // 先将强引用的对象转为弱引用指针
    __weak __typeof(self)weakSelf = self;
    
    self.referenceLoopBlock = ^{
        
        // 防止了多线程和 ARC 环境下弱引用随时被释放的问题
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // 为了防止在把 weakSelf 转换成 strongSelf 之前 weakSelf 就已经为 nil
        if (strongSelf) {
            strongSelf.name = @"123";
        }
        
    };
}

@end
