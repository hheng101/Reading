//
//  BookListCell.m
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookListCell.h"

@interface BookListCell()

@property (weak, nonatomic) IBOutlet UIImageView *MainImage;

@property (weak, nonatomic) IBOutlet UILabel *BookName;


@property (weak, nonatomic) IBOutlet UILabel *authorName;


@property (weak, nonatomic) IBOutlet UILabel *peopleNum;

@end

@implementation BookListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//+(BookListCell *)cellWithtableView:(UITableView *)tableviw
//{
//    BookListCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"BookListCell" owner:self options:nil]lastObject];
//    return cell;
//}

-(void)setModel:(BookModel *)model
{
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:[self ImageUrl:model.id]] placeholderImage:[UIImage imageNamed:@"book_cover_default"]];
    self.BookName.text = [model.name substringWithRange:NSMakeRange(0, model.name.length-2)];
    self.authorName.text = model.author;
    self.peopleNum.text = [NSString stringWithFormat:@"%d%d%d%d%d人在追",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
}

-(NSString *)ImageUrl:(NSString *)BookId
{
    NSString *Imageurl;
    if(BookId.length<6&&BookId.length>2)
    {
        Imageurl = [NSString stringWithFormat:@"http://www.bxwx8.org/image/%@/%@/%@l.jpg",[BookId substringWithRange:NSMakeRange(0, 2)],BookId,BookId];
    }
    else if(BookId.length>=6)
    {
        Imageurl = [NSString stringWithFormat:@"http://www.bxwx8.org/image/%@/%@/%@s.jpg",[BookId substringWithRange:NSMakeRange(0, 3)],BookId,BookId];
    }
    return Imageurl;
}

@end
