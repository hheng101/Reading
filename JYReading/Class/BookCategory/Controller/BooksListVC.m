//
//  BooksListVC.m
//  JYReading
//
//  Created by JourneyYoung on 16/8/31.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BooksListVC.h"
#import "BookModel.h"
@interface BooksListVC ()

@property(nonatomic,assign)NSInteger indexPage;

@property(nonatomic,strong) NSMutableArray *BookListArray;

@end

@implementation BooksListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexPage = 0;
    [self getBookList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)getBookList
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-2";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    if(self.typeId)
    {
       dic[@"typeId"] = _typeId;
    }
    
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray *arr = responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"];
        for(int i = 0;i<arr.count;i++)
        {
            NSDictionary *dic = arr[i];
            BookModel *model = [BookModel initWithDictionary:dic];
            JSLog(@"%@",model.newchapter);
            [_BookListArray addObject:model];
        }

        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}


-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.BookListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model = self.BookListArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookCell"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self ImageUrl:model.id]] placeholderImage:[UIImage imageNamed:@"book_cover_default"]];
    cell.textLabel.text = model.name;
    return cell;
}

-(NSString *)ImageUrl:(NSString *)BookId
{
    NSString *Imageurl;
    if(BookId.length<6)
    {
        Imageurl = [NSString stringWithFormat:@"http://www.bxwx8.org/image/%@/%@/%@l.jpg",[BookId substringWithRange:NSMakeRange(0, 2)],BookId,BookId];
    }
    else
    {
        Imageurl = [NSString stringWithFormat:@"http://www.bxwx8.org/image/%@/%@/%@s.jpg",[BookId substringWithRange:NSMakeRange(0, 3)],BookId,BookId];
    }
    NSLog(@"%@",Imageurl);
    return Imageurl;
}

-(NSMutableArray *)BookListArray
{
    if(!_BookListArray)
    {
        _BookListArray = [NSMutableArray array];
    }
    return _BookListArray;
}


@end
