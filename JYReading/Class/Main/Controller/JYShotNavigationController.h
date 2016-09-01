//
//  AppDelegate.m
//  仿QQ手势推出导航控制器
//
//  Created by Journey Young on 15/10/13.
//  Copyright © 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYShotNavigationController : UINavigationController
@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@end

@protocol JYShotBackProtocol <NSObject>
@optional
- (BOOL)enablePanBack:(JYShotNavigationController *)NavigationController;
- (void)startPanBack:(JYShotNavigationController *)NavigationController;
- (void)finshPanBack:(JYShotNavigationController *)NavigationController;
- (void)resetPanBack:(JYShotNavigationController *)NavigationController;
@end