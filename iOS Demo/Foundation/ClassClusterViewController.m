//
//  ClassClusterViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/12.
//

#import "ClassClusterViewController.h"

@interface ClassClusterViewController ()

@end

@implementation ClassClusterViewController

- (void)buttonTest {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeClose];
    if ([btn isKindOfClass:[UIButton class]]) {
        NSLog(@"btn isKindOfClass");
    }
    
    if ([btn isMemberOfClass:[UIButton class]]) {
        NSLog(@"btn isMemberOfClass");
    }
    NSLog(@"%@",[[btn class] debugDescription]);
    
    NSLog(@"%@", [[[UIButton buttonWithType:UIButtonTypeCustom] class] debugDescription]);
}

- (void)arrayTest {
    NSArray*array = [NSArray new];
    if ([array isKindOfClass:[NSArray class]]) {
        NSLog(@"isKindOfClass");
    }
    
    if ([array isMemberOfClass:[NSArray class]]) {
        // 未调用
        NSLog(@"isMemberOfClass");
    }
    
    //__NSArray0
    NSLog(@"%@",[[array class] debugDescription]);
    
    //__NSSingleObjectArrayI
    NSLog(@"%@", [[[NSArray arrayWithObject:@"a,b"] class] debugDescription]);
}

- (void)stringTest {
    NSString *string = @"test";
    if ([string isKindOfClass:[NSString class]]) {
        NSLog(@"isKindOfClass");
    }
    
    if ([string isMemberOfClass:[NSString class]]) {
        NSLog(@"isMemberOfClass");
    }
    
    // __NSCFConstantString
    NSLog(@"%@",[[string class] debugDescription]);
    
    // NSTaggedPointerString
    NSLog(@"%@", [[[NSString stringWithFormat:@"%d", 0] class] debugDescription]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self arrayTest];
    
    //    [self buttonTest];
    
    [self stringTest];
    
}

@end
