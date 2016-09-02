//
//  ReadBottomView.h
//  JYReading
//
//  Created by 俞洋 on 16/9/2.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadBottomViewDelegate <NSObject>

@optional
-(void)clickButton:(NSInteger) index;

@end

@interface ReadBottomView : UIView

@property(nonatomic,assign) id<ReadBottomViewDelegate> delegate;

@end
