//
//  HashOCViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/9.
//

#import "HashOCViewController.h"

@interface EqualModel : NSObject<NSCopying>

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger identifier;
- (BOOL)isEqualToModel:(EqualModel *)model;

@end

@implementation EqualModel

// 值判断
- (BOOL)isEqualToModel:(EqualModel *)model {
    if (!model) {
        return NO;
    }
    
    // 字符串都不存在或者内容相同
    BOOL haveEqualNames = (!self.name && !model.name) || [self.name isEqualToString:model.name];
    BOOL haveEqualIdentifers = self.identifier == model.identifier;
    return haveEqualNames && haveEqualIdentifers;
}

- (BOOL)isEqual:(id)object {
    NSLog(@"isEqual 被调用");
    
    // 判空
    if (!object) {
        return NO;
    }
    
    // 判断地址
    if (self == object) {
        return YES;
    }
    
    // 判断类型
    if (![object isKindOfClass:[EqualModel class]]) {
        return NO;
    }
    
    return [self isEqualToModel:(EqualModel *)object];
}

- (NSUInteger)hash
{
    NSLog(@"hash 被调用");
    return self.name.hash ^ self.identifier;
}

- (id)copyWithZone:(NSZone *)zone {
    EqualModel *model = [[[self class] allocWithZone:zone] init];
    model.name = self.name;
    model.identifier = self.identifier;
    return model;
}

@end

@interface HashOCViewController ()

@end

@implementation HashOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self testSet];
//    [self testDic];
}

- (void)testDic {
    EqualModel *model0 = [[EqualModel alloc]init];
    model0.name = @"model0";
    model0.identifier = 0;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
     当model作为key时会调用它的hash方法，并且model要实现NSCopying协议，
     因为model会被拷贝一份作为key，以防止model后续被改变
     */
    [dict addEntriesFromDictionary:@{model0 :  @"123"}];
}

- (void)testSet
{
    /*
     由于NSSet底层是由哈希表实现，所以在添加元素时会调用元素的hash方法，用于决定元素在哈希表中的位置
     当set中已有数据时，会调用元素的isEqual方法来判定是否元素相同，如果元素相同则不添加。
     但是isEqual的调用次数并不和set中元素个数相符
     */
    
    /*
     2022-08-09 15:21:58.520657+0800 iOS Demo[27597:524280] set model 0前
     2022-08-09 15:21:58.520755+0800 iOS Demo[27597:524280] hash 被调用
     2022-08-09 15:21:58.520821+0800 iOS Demo[27597:524280] set model 0后
     2022-08-09 15:21:58.520884+0800 iOS Demo[27597:524280] set model 1前
     2022-08-09 15:21:58.520933+0800 iOS Demo[27597:524280] hash 被调用
     2022-08-09 15:21:58.520983+0800 iOS Demo[27597:524280] isEqual 被调用
     2022-08-09 15:21:58.521035+0800 iOS Demo[27597:524280] set model 1后
     2022-08-09 15:21:58.521086+0800 iOS Demo[27597:524280] model0 == model1 = 1
     2022-08-09 15:21:58.521145+0800 iOS Demo[27597:524280] set count = 1
     */
    
    NSMutableSet *set = [NSMutableSet set];
    
    EqualModel *model0 = [[EqualModel alloc]init];
    model0.name = @"model0";
    model0.identifier = 0;
    NSLog(@"set model 0前");
    [set addObject:model0];
    NSLog(@"set model 0后");
    
    EqualModel *model1 = [[EqualModel alloc]init];
    model1.name = @"model0";
    model1.identifier = 0;
    NSLog(@"set model 1前");
    [set addObject:model1];
    NSLog(@"set model 1后");
    
    NSLog(@"model0 == model1 = %@", [model0 isEqualToModel:model1] ? @"YES" : @"NO");
    
    //当添加数据相同时，set内容不会新增
    NSLog(@"set count = %ld", set.count);
}

@end

