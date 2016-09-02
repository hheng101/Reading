//
//  ReadBottomView.m
//  JYReading
//
//  Created by 俞洋 on 16/9/2.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "ReadBottomView.h"

@implementation ReadBottomView

-(instancetype)init
{
    self = [super init];
    return [[[NSBundle mainBundle] loadNibNamed:@"ReadBottomView" owner:self options:nil]lastObject];
}


- (IBAction)changeBackWhite:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:1];
    }
}

- (IBAction)changeBackWhitegray:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:2];
    }
}
- (IBAction)changeBackWhiteyellow:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:3];
    }
}
- (IBAction)changeBackWhitepurple:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:4];
    }
}
- (IBAction)chapter:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:5];
    }
}
- (IBAction)fontrealse:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:6];
    }
}
- (IBAction)fontplus:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:7];
    }
}
- (IBAction)anymore:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickButton:)])
    {
        [self.delegate clickButton:8];
    }
}

@end
