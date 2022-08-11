//
//  StaticDynamicTypeViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/10.
//

#import "StaticDynamicTypeViewController.h"

@interface Person1 : NSObject

@property (nonatomic,strong) NSString *name;
-(void)run;

@end

@implementation Person1

-(void)run{
    NSLog(@"run");
}

@end

@interface Student : Person1

-(void)eat;

@end

@implementation Student

-(void)eat{
    NSLog(@"eat");
}

@end

@interface StaticDynamicTypeViewController ()

@end

@implementation StaticDynamicTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 静态类型
    Person1 *p = [[Person1 alloc]init];
    p.name = @"ABC";
    [p run];
    
    // 动态类型
    id obj1 = [[Person1 alloc]init];
//    obj1.name 点语法只可以是静态类型调用，动态类型不支持
    [obj1 eat];// 动态类型可以调用任何方法，即使不是自己的方法，eat就是子类的方法，是不能调用的。
    
    /*
     综上所述，构造方法返回instanceType为了返回静态类型
     */
}

@end
