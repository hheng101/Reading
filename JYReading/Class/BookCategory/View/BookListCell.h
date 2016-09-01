//
//  BookListCell.h
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@interface BookListCell : UITableViewCell
//+(BookListCell *)cellWithtableView:(UITableView *)tableviw;

@property(nonatomic,strong)BookModel *model;

@end
