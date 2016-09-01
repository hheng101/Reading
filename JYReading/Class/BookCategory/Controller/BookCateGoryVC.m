//
//  BookCateGoryVC.m
//  JYReading
//
//  Created by 俞洋 on 16/8/31.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookCateGoryVC.h"
#import "AFNetworking.h"
#import "CateModel.h"
#import "BooksListVC.h"
@interface BookCateGoryVC ()
@property(nonatomic,strong) NSMutableArray *dataList;


@end

@implementation BookCateGoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getCateArray];
    // Do any additional setup after loading the view.
}

-(void)getCateArray
{
     AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-3";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"showapi_res_body"];
        NSArray *dataArray = [CateModel objectArrayWithKeyValuesArray:dataDic[@"typeList"]];
        self.dataList = [NSMutableArray arrayWithArray:dataArray];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString *str = [NSString stringWithFormat:@"rank_%ld",indexPath.row%7+1];
    cell.imageView.image = [UIImage imageNamed:str];
    CateModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BooksListVC *vc = [[BooksListVC alloc]init];
    CateModel *model = self.dataList[indexPath.row];
    vc.typeId = model.id;
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
