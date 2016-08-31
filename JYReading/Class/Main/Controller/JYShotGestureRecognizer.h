//
//  AppDelegate.m
//  仿QQ手势推出导航控制器
//
//  Created by Journey Young on 15/10/13.
//  Copyright © 2015年 JY. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JYShotGestureRecognizer : UIPanGestureRecognizer
@property (readonly, nonatomic) UIEvent *event;
- (CGPoint)beganLocationInView:(UIView *)view;
@end
