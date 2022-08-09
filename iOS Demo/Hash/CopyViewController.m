//
//  CopyViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/9.
//

#import "CopyViewController.h"

@interface Phone : NSObject<NSCopying>
@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,assign,readonly) NSInteger price;

- (instancetype)initWithName:(NSString *)name withPrice:(NSInteger)price;
@end


@implementation Phone
- (instancetype)initWithName:(NSString *)name withPrice:(NSInteger)price{
    self = [super init];
    if (self) {
        _name = [name copy];
        _price = price;
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone{
    /*
     一定要通过[self class]方法返回的对象调用allocWithZone:方法。因为指针可能实际指向的是PersonModel的子类。这种情况下，通过调用[self class]，就可以返回正确的类的类型对象
     */
    Phone *phone = [[[self class] allocWithZone:zone] initWithName:_name withPrice:_price];
    return phone;
}

@end

@interface CopyViewController ()

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Phone *p = [[Phone alloc]initWithName:@"iPhone" withPrice:999];
    NSLog(@"%p--%@--%zd",p,p.name,p.price);
    Phone *p1 = [p copy];
    NSLog(@"%p--%@--%zd",p1,p1.name,p1.price);

}

@end
