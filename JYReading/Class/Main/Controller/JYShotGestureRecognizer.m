//
//  AppDelegate.m
//  仿QQ手势推出导航控制器
//
//  Created by Journey Young on 15/10/13.
//  Copyright © 2015年 JY. All rights reserved.
//


#import "JYShotGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface JYShotGestureRecognizer ()
@property (assign, nonatomic) CGPoint beganLocation;
@property (strong, nonatomic) UIEvent *event;
@property (assign, nonatomic) NSTimeInterval beganTime;
@end

@implementation JYShotGestureRecognizer

//开始触摸，获取开始触摸的位置，触摸时间以及时间戳
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beganLocation = [touch locationInView:self.view];
    self.event = event;
    self.beganTime = event.timestamp;
    [super touchesBegan:touches withEvent:event];
}

#pragma mark 识别器接收到不能识别为它的手势的一系列触摸。响应方法不会被调用 并且 识别器将重置为possible状态
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible && event.timestamp - self.beganTime > 0.3) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

#pragma mark 重置，属性初始化
- (void)reset
{
    self.beganLocation = CGPointZero;
    self.event = nil;
    self.beganTime = 0;
    [super reset];
}

#pragma mark 获取初始位置坐标
- (CGPoint)beganLocationInView:(UIView *)view
{
    return [view convertPoint:self.beganLocation fromView:self.view];
}

@end
