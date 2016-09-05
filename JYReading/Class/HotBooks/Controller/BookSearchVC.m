//
//  BookSearchVC.m
//  JYReading
//
//  Created by 俞洋 on 16/9/5.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookSearchVC.h"

@interface BookSearchVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *searchField;

@property(nonatomic,strong)NSMutableArray *booklist;

@end

@implementation BookSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sethead];
    // Do any additional setup after loading the view.
}

-(void)sethead
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setTableHeaderView:view];
    self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.font = [UIFont systemFontOfSize:12.0];
    self.searchField.placeholder = @"请输入小说名";
    self.searchField.layer.cornerRadius = 5.0;
    self.searchField.layer.masksToBounds = YES;
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *leftviewimage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
    leftviewimage.image = [UIImage imageNamed:@"search"];
    [leftview addSubview:leftviewimage];
    self.searchField.keyboardType = UIKeyboardTypeWebSearch;
    self.searchField.leftView = leftview;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:self.searchField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchField resignFirstResponder];
    [self.view endEditing:YES];
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
