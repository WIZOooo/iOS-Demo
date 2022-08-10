//
//  ReadWriteLockViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/10.
//

#import "ReadWriteLockViewController.h"

@interface ReadWriteLockViewController ()

@property (strong, nonatomic) dispatch_queue_t queue;
@property (nonatomic, assign) NSInteger countFlag;

@end

@implementation ReadWriteLockViewController

@synthesize countFlag = _countFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int index = 0; index < 10; index++) {
        self.countFlag;
    }
    
    self.countFlag = 10;
    
    for (int index = 0; index < 10; index++) {
        self.countFlag;
    }
}

- (dispatch_queue_t)queue{
    if (!_queue) {
        _queue = dispatch_queue_create("my_lock", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

- (void)setCountFlag:(NSInteger)countFlag{
    dispatch_barrier_async(self.queue, ^{
        // 在新开线程执行
        NSLog(@"countflag被赋值,Thread：%@ ",[NSThread currentThread]);
        self->_countFlag = countFlag;
    });
}

- (NSInteger)countFlag
{
    __block NSInteger tempCountFlag;
    dispatch_sync(self.queue, ^{
        // 在主线程执行
        NSLog(@"Thread：%@ ",[NSThread currentThread]);
        tempCountFlag = self->_countFlag;
    });
    return tempCountFlag;
}

- (NSInteger)countFlag:(NSInteger)index {
    return self.countFlag;
}

@end
