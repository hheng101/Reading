//
//  CharpterVC.m
//  JYReading
//
//  Created by JourneyYoung on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "CharpterVC.h"
#import "ChapterModel.h"
@interface CharpterVC ()

@property(nonatomic,strong)NSMutableArray *chaperList;

@end

@implementation CharpterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [KVNProgress showWithStatus:@"正在加载.."];
    [self getCharpter];
}


-(void)getCharpter
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-1";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    dic[@"bookId"] = self.bookID;
    
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JSLog(@"%@",responseObject);
        NSDictionary *dataDict = responseObject[@"showapi_res_body"][@"book"];
        NSArray *dataArrr = [ChapterModel objectArrayWithKeyValuesArray:dataDict[@"chapterList"]];
        [self.chaperList addObjectsFromArray:dataArrr];
        [KVNProgress dismiss];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络异常"];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chaperList.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"chapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ChapterModel *model = self.chaperList[indexPath.row];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    }
    cell.textLabel.text = model.name;
    return cell;
}


-(NSMutableArray *)chaperList
{
    if(!_chaperList)
    {
        _chaperList = [NSMutableArray array];
    }
    return _chaperList;
}



@end
