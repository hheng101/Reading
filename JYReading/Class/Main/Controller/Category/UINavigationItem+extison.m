//
//  UINavigationItem+extison.m
//  HaveGlass
//
//  Created by 菲尔普斯防水山寨MBP on 15-6-28.
//  Copyright (c) 2015年 CQUt. All rights reserved.
//

#import "UINavigationItem+extison.h"

@implementation UINavigationItem (extison)

-(void)setThetitle:(NSString *)thetitle
{
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.text = thetitle;
    titlelabel.textAlignment  = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.titleView = titlelabel;
}
@end
