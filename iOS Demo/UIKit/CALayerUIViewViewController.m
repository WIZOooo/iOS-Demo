//
//  CALayerUIViewViewController.m
//  iOS Demo
//
//  Created by iMac on 2022/8/16.
//

#import "CALayerUIViewViewController.h"

@interface CALayerUIViewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation CALayerUIViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = true;
    
//    [self groupOpacityOffScreenRenderTest];
//    [self shadowOffScreenRenderTest];
    [self cornerRadiusOffScreenRenderTest];
//    [self boundsTest];
//    [self scrollViewTest];
//    [self anchorPointTest];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
}

#pragma mark - 离屏渲染
/// 设置圆角产生离屏渲染
- (void)cornerRadiusOffScreenRenderTest {
    /// 当不设置contents属性时，且也没有子图层时，不会发生离屏渲染
    /// 所以设置圆角产生离屏渲染的条件是
    /// 当前图层中有多个「内容」需要被裁剪，
    /// 内容包括自身图层的backgroundColor，contents，或者子图层的backgroundColor，content
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200.0, 200.0)];
    [self.view addSubview:view1];
//    view1.backgroundColor = UIColor.redColor;
    view1.layer.cornerRadius = 100.0;
    view1.clipsToBounds = YES;
    view1.layer.contents = (__bridge id)[UIImage imageNamed:@"CALayerUIViewDemo/screenshot"].CGImage;

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100.0, 100.0)];
//    view2.backgroundColor = UIColor.blueColor;
    view2.layer.contents = (__bridge id)[UIImage imageNamed:@"CALayerUIViewDemo/screenshot"].CGImage;
    [view1 addSubview:view2];
}

/// 设置阴影产生离屏渲染
- (void)shadowOffScreenRenderTest {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200.0, 200.0)];
    [self.view addSubview:view1];
    view1.backgroundColor = UIColor.redColor;
    
    CALayer *shadowLayer = view1.layer;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 1.0;
    shadowLayer.shadowRadius = 2.0;
    shadowLayer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    /// 打开这句之后就不会触发离屏渲染，
    /// 因为设置过shadowPath就直接告诉GPU阴影的位置，
    /// 所以GPU不需要将图层及其子图层在单独组合一遍了，所以避免了离屏渲染
//    shadowLayer.shadowPath = CGPathCreateWithRect(shadowLayer.bounds, NULL);
}

/// 开启组不透明选项时，父图层设置的透明度会对整个图层树应用，就是等整个图层树全部画完以后，再应用一个透明度。
/// 关闭该选项后，父图层的透明度会应用到子图层上面，最终通过透明度透视展现结果。
/// 开启选项会产生离屏渲染的原因是，应用透明度就需要整个图层树全部绘制完毕，所以才会需要离屏空间来先绘制整个图层树。
- (void)groupOpacityOffScreenRenderTest {
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(50, 150);
    button1.alpha = 0.5;
    button1.layer.allowsGroupOpacity = false;// 关闭选项
    [self.view addSubview:button1];
    
    UIButton *button2 = [self customButton];
    button2.center = CGPointMake(250, 150);
    button2.alpha = 0.5;
    button2.layer.allowsGroupOpacity = true;// 开启选项
    [self.view addSubview:button2];
}

- (UIButton *)customButton
{
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    
    [button addSubview:label];
    return button;
}

#pragma mark - anchorPoint & position
/// position.x = frame.origin.x + anchorPoint.x * bounds.size.width
/// position.y = frame.origin.y + anchorPoint.y * bounds.size.height
- (void)anchorPointTest {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];//添加到self.view
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view2];//添加到view1上,[此时view1坐标系左上角起点为(-20,-20)]
    
    NSLog(@"view1 position:%@ \n view1 frame:%@",NSStringFromCGPoint(view1.layer.position),NSStringFromCGRect(view1.frame));
    
    /// 改变anchorPoint的值，position不会发生改变，frame会发生改变
    /// 原因是position是视图中心点在父视图中的位置，
    /// anchorPoint描述的是这个中心点在当前视图中的相对位置，默认是0.5,0.5
    /// 所以当anchorPoint发生变化时，只是中心点的相对位置发生变化，中心点的绝对位置在父视图中没有变化
    /// 所以才会position不变，只改变frame
    view1.layer.anchorPoint = CGPointMake(0.0, 0.0);
    
    NSLog(@"view1 position:%@ \n view1 frame:%@",NSStringFromCGPoint(view1.layer.position),NSStringFromCGRect(view1.frame));
}

#pragma mark - bounds
/// 修改视图的bounds实际上会影响其子视图的布局，自身的位置是不会改变的。
/// 设置bounds数值是相对当前视图展示的起始点来说的。
/// 比如设置bounds x方向为5，y方向为10，视图展示起点在视图自身的坐标系中就变成了(5, 10)。
/// 所以该视图的子视图在屏幕上的位置会向左偏移5，向上偏移10
/// 也就是在横坐标和纵坐标叠加-x,-y
- (void)boundsTest {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];//添加到self.view
    NSLog(@"view1 frame:%@========view1 bounds:%@",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds));
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view2];//添加到view1上,[此时view1坐标系左上角起点为(-20,-20)]
    NSLog(@"view2 frame:%@========view2 bounds:%@",NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds));
    
    [view1 setBounds:CGRectMake(-20, -20, 200, 200)];
}

/// scrollView本质上就是利用不断修改bounds来使得内容滚动的
- (void)scrollViewTest {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100,0, 50, 1000)];
    self.imageView.image = [UIImage imageNamed:@"CALayerUIViewDemo/screenshot"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.frame.size;
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollview[\n contentoffset:%@ \n bounds:%@",NSStringFromCGPoint(scrollView.contentOffset) ,NSStringFromCGRect(self.scrollView.bounds));
//    NSLog(@"imageview[\n frame:%@ \n bounds:%@",NSStringFromCGRect(self.imageView.frame),NSStringFromCGRect(self.imageView.bounds));
}


@end
