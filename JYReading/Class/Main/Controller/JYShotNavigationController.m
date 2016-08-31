//
//  AppDelegate.m
//  仿QQ手势推出导航控制器
//
//  Created by Journey Young on 15/10/13.
//  Copyright © 2015年 JY. All rights reserved.
//


#import "JYShotNavigationController.h"
#import "JYShotGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+Snapshot.h"
#import "UIBarButtonItem+Extension.h"
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

static const NSString *contentImageKey  = @"contentImageKey";
static const NSString *barImageKey      = @"barImageKey";
static const NSString *contentFrameKey  = @"contentFrameKey";

@interface JYShotNavigationController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) JYShotGestureRecognizer *pan;
@property (strong, nonatomic) NSMutableArray *shotStack;

//先前的镜像图片
@property (strong, nonatomic) UIImageView *previousMirrorView;
@property (strong, nonatomic) UIImageView *previousBarMirrorView;
@property (strong, nonatomic) UIView *previousOverLayView;
@property (assign, nonatomic) BOOL animatedFlag;

@property (readonly, nonatomic) UIView *controllerWrapperView;
@property (weak, nonatomic) UIView *barBackgroundView;
@property (weak, nonatomic) UIView *barBackIndicatorView;

@property (assign, nonatomic) CGFloat showViewOffsetScale;
@property (assign, nonatomic) CGFloat showViewOffset;

@end

@implementation JYShotNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏的颜色和字体颜色
    
    
    
    NSDictionary *dic=[[NSDictionary alloc]init];
    dic=@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationBar setTitleTextAttributes:dic];
    [self.navigationBar setBackgroundColor:JSColor(46, 158, 121)];
    self.navigationBar.barTintColor = JSColor(46, 158, 121);
    self.navigationBar.translucent = NO;
    if (SYSTEM_VERSION >= 7) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    _pan = [[JYShotGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    
    //设定为单击
    _pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_pan];

    _shotStack = [NSMutableArray array];
    _previousMirrorView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _previousMirrorView.backgroundColor = [UIColor clearColor];
    
    _previousOverLayView = [[UIView alloc] initWithFrame:_previousMirrorView.bounds];
    _previousOverLayView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [_previousMirrorView addSubview:_previousOverLayView];
    
    
    _previousBarMirrorView = [[UIImageView alloc] initWithFrame:self.navigationBar.bounds];
    _previousBarMirrorView.backgroundColor = [UIColor clearColor];
    
    self.showViewOffsetScale = 1 / 3.0;
    self.showViewOffset = self.showViewOffsetScale * self.view.frame.size.width;
    
    
    //self.navigationBar.translucent = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.navigationBar.alpha = 1;
}


- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
}

#pragma mark 推进栈控制器时的操作
/**
 *在推进前先获取当前的控制器和导航条并截图
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *previousViewController = [self.viewControllers lastObject];
    
    if (previousViewController) {
        
        NSMutableDictionary *shotInfo = [NSMutableDictionary dictionary];
        UIImage *barImage = [self barSnapshot];
        
        double delayInSeconds = animated ? 0.35 : 0.1; // 等按钮状态恢复到normal状态
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            UIImage *contentImage = [previousViewController.view snapshot];
            
            shotInfo[contentImageKey] = contentImage;//主控制器截图
            shotInfo[barImageKey] = barImage;//导航条截图
            shotInfo[contentFrameKey] = [NSValue valueWithCGRect:previousViewController.view.frame];//屏幕尺寸
            
            [self.shotStack addObject:shotInfo];
        });
    }
    
    if(self.viewControllers.count >0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewControllerAnimated:) image:@"back" highImage:nil];
    }
    
    // 动画标识，在动画的情况下，禁掉右滑手势
    [self startAnimated:animated];
    
    [super pushViewController:viewController animated:animated];
}


/**
 *推出控制器
 *推出时将截屏信息栈最后一个对象删除
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
{
    [self.shotStack removeLastObject];
    
    [self startAnimated:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    // TODO: shotStack handle
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.shotStack removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}


#pragma mark 拖移手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIGestureRecognizerState state = pan.state;
    switch (state) {
            //开始状态
        case UIGestureRecognizerStateBegan:{
            NSDictionary *shotInfo = [self.shotStack lastObject];
            UIImage *contentImage = shotInfo[contentImageKey];
            UIImage *barImage = shotInfo[barImageKey];
            CGRect rect = [shotInfo[contentFrameKey] CGRectValue];
            
            self.previousMirrorView.image = contentImage;
            self.previousMirrorView.frame = rect;
            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0);
            [self.controllerWrapperView insertSubview:self.previousMirrorView belowSubview:self.visibleViewController.view];
            
            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
            
            self.previousBarMirrorView.image = barImage;
            self.previousBarMirrorView.frame = self.navigationBar.bounds;
            self.previousBarMirrorView.alpha = 0;
            [self.navigationBar addSubview:self.previousBarMirrorView ];
            [self startPanBack];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translationPoint = [self.pan translationInView:self.view];

            if (translationPoint.x < 0) translationPoint.x = 0;
            if (translationPoint.x > 320) translationPoint.x = 320;
            
            CGFloat k = translationPoint.x / 320;

            [self barTransitionWithAlpha:1 - k];
            self.previousBarMirrorView.alpha = k;
            
            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset + translationPoint.x * self.showViewOffsetScale, 0);
            
            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2 * (1 - k)];
            self.visibleViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,translationPoint.x, 0);
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            
            CGPoint velocity = [self.pan velocityInView:self.view];
            BOOL reset = velocity.x < 0;
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat alpha = reset ? 1.f : 0.f;
                [self barTransitionWithAlpha:alpha];
                self.previousBarMirrorView.alpha = 1 - alpha;
                self.previousMirrorView.transform = reset ? CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0) : CGAffineTransformIdentity;
                self.visibleViewController.view.transform = reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, 320, 0);
                self.previousOverLayView.backgroundColor = reset ? [[UIColor grayColor] colorWithAlphaComponent:0.2] : [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [self barTransitionWithAlpha:1];
                
                self.visibleViewController.view.transform = CGAffineTransformIdentity;
                self.previousMirrorView.transform = CGAffineTransformIdentity;
                self.previousMirrorView.image = nil;

                self.previousBarMirrorView.image = nil;
                self.previousBarMirrorView.alpha = 0;

                [self.previousMirrorView removeFromSuperview];
                [self.previousBarMirrorView removeFromSuperview];
                
                self.barBackgroundView = nil;
                
                [self finshPanBackWithReset:reset];
                
                if (!reset) {
                    [self popViewControllerAnimated:NO];
                }
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark GestureRecognizer Delegate

#define MIN_TAN_VALUE tan(M_PI/6)

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count < 2) return NO;//栈中只有一个控制器时不执行操作
    if (self.animatedFlag) return NO;//正在动画中不执行操作-
    if (![self enablePanBack]) return NO; // 询问当前viewconroller 是否允许右滑返回
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.controllerWrapperView];
    if (touchPoint.x < 0 || touchPoint.y < 10 || touchPoint.x > 220) return NO;

    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (translation.x <= 0) return NO;
    
    // 是否是右滑
    BOOL succeed = fabs(translation.y / translation.x) < MIN_TAN_VALUE;
    
    return succeed;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer != self.pan) return NO;//其他手势，不执行操作
    if (self.pan.state != UIGestureRecognizerStateBegan) return NO;
    
    if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {

        return YES;
    }

    CGPoint touchPoint = [self.pan beganLocationInView:self.controllerWrapperView];

    // 点击区域判断 如果在左边 30 以内, 强制手势后退
    if (touchPoint.x < 30) {
        
        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
        return YES;
    }
    
    // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0) {
            
            [self cancelOtherGestureRecognizer:otherGestureRecognizer];
            return YES;
        }
    }

    return NO;
}

- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSSet *touchs = [self.pan.event touchesForGestureRecognizer:otherGestureRecognizer];
    [otherGestureRecognizer touchesCancelled:touchs withEvent:self.pan.event];
}



#pragma mark 开始动画
- (void)startAnimated:(BOOL)animated
{
    self.animatedFlag = YES;
    
    NSTimeInterval delay = animated ? 0.8 : 0.1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedAnimated) object:nil];
    [self performSelector:@selector(finishedAnimated) withObject:nil afterDelay:delay];
}

- (void)finishedAnimated
{
    self.animatedFlag = NO;
}

- (void)barTransitionWithAlpha:(CGFloat)alpha
{
    UINavigationItem *topItem = self.navigationBar.topItem;
    
    UIView *topItemTitleView = topItem.titleView;

    if (!topItemTitleView) { // 找titleview
        UIView *defaultTitleView = nil;
        @try {
            defaultTitleView = [topItem valueForKey:@"_defaultTitleView"];
        }
        @catch (NSException *exception) {
            defaultTitleView = nil;
        }
        
        topItemTitleView = defaultTitleView;
    }
    
    topItemTitleView.alpha = alpha;

    if (!topItem.leftBarButtonItems.count) { // 找后退按钮Item
        UINavigationItem *backItem = self.navigationBar.backItem;
        UIView *backItemBackButtonView = nil;
        
        @try {
            backItemBackButtonView = [backItem valueForKey:@"_backButtonView"];
        }
        @catch (NSException *exception) {
            backItemBackButtonView = nil;
        }
        backItemBackButtonView.alpha = alpha;
        self.barBackIndicatorView.alpha = alpha;
    }
    
    
    [topItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
    
    [topItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
}




- (UIPanGestureRecognizer *)panGestureRecognizer
{
    return self.pan;
}

- (UIView *)controllerWrapperView
{
    return self.visibleViewController.view.superview;
}

- (UIView *)barBackgroundView
{
    if (_barBackgroundView) return _barBackgroundView;
    
    for (UIView *subview in self.navigationBar.subviews) {
        if (!subview.hidden && subview.frame.size.height >= self.navigationBar.frame.size.height
            && subview.frame.size.width >= self.navigationBar.frame.size.width) {
            _barBackgroundView = subview;
            break;
        }
    }
    return _barBackgroundView;
}

- (UIView *)barBackIndicatorView
{
    if (!_barBackIndicatorView) {
        for (UIView *subview in self.navigationBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                _barBackIndicatorView = subview;
                break;
            }
        }
        
    }
    return _barBackIndicatorView;
}

//导航条截图
- (UIImage *)barSnapshot
{
    self.barBackgroundView.hidden = YES;
    UIImage *viewImage = [self.navigationBar snapshot];
    self.barBackgroundView.hidden = NO;
    return viewImage;
}


#pragma mark delegate

- (BOOL)enablePanBack
{
    BOOL enable = YES;
    if ([self.visibleViewController respondsToSelector:@selector(enablePanBack:)]) {
        UIViewController<JYShotBackProtocol> * viewController = (UIViewController<JYShotBackProtocol> *)self.visibleViewController;
        enable = [viewController enablePanBack:self];
    }
    return enable;
}

- (void)startPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(startPanBack:)]) {
        UIViewController<JYShotBackProtocol> * viewController = (UIViewController<JYShotBackProtocol> *)self.visibleViewController;
        [viewController startPanBack:self];
    }
}

- (void)finshPanBackWithReset:(BOOL)reset
{
    if (reset) {
        [self resetPanBack];
    } else {
        [self finshPanBack];
    }
}

- (void)finshPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(finshPanBack:)]) {
        UIViewController<JYShotBackProtocol> * viewController = (UIViewController<JYShotBackProtocol> *)self.visibleViewController;
        [viewController finshPanBack:self];
    }
}

- (void)resetPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(resetPanBack:)]) {
        UIViewController<JYShotBackProtocol> * viewController = (UIViewController<JYShotBackProtocol> *)self.visibleViewController;
        [viewController resetPanBack:self];
    }
}

@end