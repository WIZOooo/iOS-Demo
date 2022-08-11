//
//  SelfSuperViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/11.
//

#import "SelfSuperViewController.h"

@interface Father : NSObject

@end

@implementation Father

- (instancetype)init
{
//    self = [Father alloc];
    self = [[self class] alloc];
    return self;
}

@end

@interface Son : Father

- (void)testLog;

@end

@implementation Son

- (instancetype)init
{
    if (self = [super init]) {
        // 打印结果都是Son
        NSLog(@"[self class] : %@", NSStringFromClass([self class]));
        NSLog(@"[super class] : %@", NSStringFromClass([super class]));
    }
    return  self;
}

- (void)testLog {
    
}

@end

@interface SelfSuperViewController ()

@end

@implementation SelfSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Son *son = [Son new];
    [son testLog];
}

@end
