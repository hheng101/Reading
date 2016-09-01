//
//  BooksListVC.m
//  JYReading
//
//  Created by JourneyYoung on 16/8/31.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BooksListVC.h"
#import "BookModel.h"
#import "BookListCell.h"
#import "BookIntroduceVC.h"
@interface BooksListVC ()

@property(nonatomic,assign)NSInteger indexPage;

@property(nonatomic,strong) NSMutableArray *BookListArray;

@end

@implementation BooksListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BookListCell" bundle:nil] forCellReuseIdentifier:@"BookListCell"];
    
    self.indexPage = 1;
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [self.tableView setTableFooterView:footer];
    
    [self setupUpRefresh];
    [self setupDownRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//上拉加载更多
- (void)setupUpRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载";
    self.tableView.footerRefreshingText = @"正在拼命加载哟，请稍后";
}


//下拉刷新
- (void)setupDownRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerrefresh)];
    self.tableView.headerPullToRefreshText = @"下拉加载更多";
    self.tableView.headerReleaseToRefreshText = @"松开立即刷新";
    self.tableView.headerRefreshingText = @"正在拼命加载哟，请稍后";
    
    // 马上加载数据
    [self.tableView headerBeginRefreshing];
}

-(void)headerrefresh
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
    
    [mgr GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.BookListArray removeAllObjects];
        JSLog(@"%@",responseObject);
        NSArray *arr = responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"];
        for(int i = 0;i<arr.count;i++)
        {
            NSDictionary *dic = arr[i];
            BookModel *model = [BookModel initWithDictionary:dic];
            [_BookListArray addObject:model];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络状态异常"];
    }];
}


-(void)footerRereshing
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-2";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    dic[@"page"] = [NSString stringWithFormat:@"%ld",self.indexPage+1];
    if(self.typeId)
    {
        dic[@"typeId"] = _typeId;
    }
    
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.indexPage ++;
        NSArray *arr = responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"];
        for(int i = 0;i<arr.count;i++)
        {
            NSDictionary *dic = arr[i];
            BookModel *model = [BookModel initWithDictionary:dic];
            [_BookListArray addObject:model];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络状态异常"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model = self.BookListArray[indexPath.row];
    BookListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookListCell"];
    cell.model = model;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookIntroduceVC *vc = [[BookIntroduceVC alloc]init];
    BookModel *model = self.BookListArray[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
    NSLog(@"%@",Imageurl);
    return Imageurl;
}

-(NSMutableArray *)BookListArray
{
    if(!_BookListArray)
    {
        self.BookListArray = [NSMutableArray array];
    }
    return _BookListArray;
}


@end
