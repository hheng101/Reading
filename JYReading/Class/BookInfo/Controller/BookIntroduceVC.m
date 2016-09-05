//
//  BookIntroduceVC.m
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookIntroduceVC.h"
#import "ReadingVC.h"
#import "FMDB.h"
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
        //打开数据库
    
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
        NSString *documentDirectory = [paths objectAtIndex:0];
    
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    
        FMDatabase
    
        *db = [FMDatabase databaseWithPath:dbPath] ;
    
        if (![db open]) {
    
            [KVNProgress showErrorWithStatus:@"数据库打开失败"];
    
            return ;
    
        }
        if ([db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'BookTable' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'bookid' TEXT, 'author' TEXT, 'name' TEXT, 'newchapter' TEXT, 'size' TEXT, 'type' TEXT, 'typeName' TEXT, 'updateTime' TEXT, 'imageurl' TEXT)"];
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
    
        }
    
        if ([db open]) {
            NSString *insertSql1= [NSString stringWithFormat:
                                   @"INSERT INTO 'BookTable' ('bookid', 'author', 'name', 'newchapter', 'size', 'type', 'typeName', 'updateTime', 'imageurl') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", _model.id, _model.author, _model.name, _model.newchapter, _model.size, _model.type, _model.typeName, _model.updateTime, [self ImageUrl:_model.id]];
            BOOL res = [db executeUpdate:insertSql1];
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                [KVNProgress showSuccessWithStatus:@"加入书架成功！"];
            }
            [db close];
            
        }
}


- (IBAction)ReadingNow:(id)sender {
    ReadingVC *vc = [[ReadingVC alloc]init];
    vc.bookmodel = self.model;
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
