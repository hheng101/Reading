//
//  BookIntroduceVC.m
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookIntroduceVC.h"
#import "ReadingVC.h"
@interface BookIntroduceVC ()
@property (weak, nonatomic) IBOutlet UIImageView *MainImage;

@property (weak, nonatomic) IBOutlet UILabel *BookName;

@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UILabel *booksize;
@property (weak, nonatomic) IBOutlet UIButton *addtoBook;
@property (weak, nonatomic) IBOutlet UIButton *readNow;
@property (weak, nonatomic) IBOutlet UILabel *newcharpter;

@end

@implementation BookIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_model.name substringWithRange:NSMakeRange(0, _model.name.length-2)];
    self.addtoBook.layer.cornerRadius = 6.0;
    self.addtoBook.layer.masksToBounds = YES;
    self.addtoBook.layer.borderWidth = 0.5;
    self.addtoBook.layer.borderColor = JSColor(46, 158, 121).CGColor;
    
    self.readNow.layer.cornerRadius = 6.0;
    self.readNow.layer.masksToBounds = YES;
    self.readNow.layer.borderWidth = 0.5;
    self.readNow.layer.borderColor = JSColor(46, 158, 121).CGColor;
    
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:[self ImageUrl:_model.id]] placeholderImage:[UIImage imageNamed:@"book_cover_default"]];
    self.BookName.text = [_model.name substringWithRange:NSMakeRange(0, _model.name.length-2)];
    self.author.text = [NSString stringWithFormat:@"作者：%@",_model.author];
    self.booksize.text = [NSString stringWithFormat:@"大小：%@",_model.size];
    self.newcharpter.text = [NSString stringWithFormat:@"更新:%@",_model.newchapter];
    // Do any additional setup after loading the view from its nib.
}

//-(void)setModel:(BookModel *)model
//{
//    _model = model;
//    
//}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addtoBookStair:(id)sender {
}


- (IBAction)ReadingNow:(id)sender {
    ReadingVC *vc = [[ReadingVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
