//
//  ReadingVC.m
//  JYReading
//
//  Created by 俞洋 on 16/9/1.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "ReadingVC.h"
#import "E_Paging.h"
#import "JYShotNavigationController.h"
#import "CharpterVC.h"
#import "ReadBottomView.h"
#import "ChapterModel.h"
@interface ReadingVC ()<UIScrollViewDelegate,JYShotBackProtocol,ReadBottomViewDelegate>

@property(nonatomic,strong)UIScrollView *MainScroller;
//分页的字符串
@property(nonatomic,strong)NSMutableArray *textArray;
//复用池
@property(nonatomic,strong)NSMutableArray *LabelsArray;

@property(nonatomic,assign)CGFloat lastX;

@property(nonatomic,assign)NSInteger totalPage;

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,strong)NSMutableArray *rangeOfPages;

@property(nonatomic,strong)E_Paging *pageManager;

@property(nonatomic,strong)UIImageView *backImage;

@property(nonatomic,strong)NSMutableArray *ChapterArray;
//当前章节
@property(nonatomic,strong)ChapterModel *currentCharpterModel;
//当前第几章
@property(nonatomic,assign)NSInteger currentChapterIndex;
//章节复用池
@property(nonatomic,strong)NSMutableArray *ChaptersRepeatArray;
//缓存下一章
@property(nonatomic,strong)NSString *cacheNextText;
//下一章缓存状态
@property(nonatomic,assign)BOOL isCacheNext;
//缓存上一章
@property(nonatomic,strong)NSString *cacheBeforeText;
//上一章缓存状态
@property(nonatomic,assign)BOOL isCacheBefore;
//是否获取下一章节
@property(nonatomic,assign)BOOL isGetNextChapter;
//下一章缓存数组
@property(nonatomic,strong)NSMutableArray *cacheNextArray;
//上一章缓存数组
@property(nonatomic,strong)NSMutableArray *cacheBeforeArray;
@property(nonatomic,strong)UILabel *cacheNextLabel;

@property(nonatomic,strong)UILabel *cacheBeforeLabel;

@end

@implementation ReadingVC

-(BOOL)enablePanBack:(JYShotNavigationController *)NavigationController
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imView.image = [UIImage imageNamed:@"body_bg4"];
    [self.view addSubview:imView];
    self.backImage = imView;
    self.textArray = [NSMutableArray array];
    self.navigationController.navigationBar.hidden = YES;
    self.currentPage = 0;
    
    
    [KVNProgress showWithStatus:@"正在加载章节.."];
    [self getCharpter];
}

//获取章节列表
-(void)getCharpter
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-1";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    dic[@"bookId"] = self.bookmodel.id;
    
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict = responseObject[@"showapi_res_body"][@"book"];
        NSArray *arr = [ChapterModel objectArrayWithKeyValuesArray:dataDict[@"chapterList"]];
        self.ChapterArray = [NSMutableArray arrayWithArray:arr];
        //第一次进来取第一章
        ChapterModel *chapterModel= self.ChapterArray[0];
        self.currentChapterIndex = 0;
        self.currentCharpterModel = chapterModel;
        NSLog(@"%@,%@",responseObject,chapterModel.cid);
        
        if(chapterModel)
        {
            [self getTextDate:chapterModel];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络异常"];
    }];
}

//获取章节详细
-(void)getTextDate:(ChapterModel *)model
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://route.showapi.com/211-4";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    dic[@"bookId"] = self.bookmodel.id;
    dic[@"cid"] = model.cid;
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"showapi_res_body"];
        [self loadtext:dic[@"txt"]];
        [KVNProgress dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络异常"];
    }];
}


//获取上一章

//获取下一章
-(void)getnextChapter
{
    if(self.currentChapterIndex == self.ChapterArray.count-1)
    {
        return;
    }
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    ChapterModel *model = self.ChapterArray[self.currentChapterIndex+1];
    NSString *url = @"http://route.showapi.com/211-4";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"showapi_appid"] = @"23906";
    dic[@"showapi_sign"] = @"91e731cddb854c9cb61db7f6c4ac7b49";
    dic[@"bookId"] = self.bookmodel.id;
    dic[@"cid"] = model.cid;
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"showapi_res_body"];
        self.cacheNextText = dic[@"txt"];
        
        //[KVNProgress dismiss];
        NSMutableString *strcache = [NSMutableString stringWithString:self.cacheNextText];
        NSMutableString *str = [NSMutableString stringWithFormat:@"\t%@",strcache];
        [str replaceOccurrencesOfString:@"<br /><br />" withString:@"\n\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
        self.pageManager = [[E_Paging alloc]init];
        self.pageManager.contentText = str;
        self.pageManager.contentFont = 14;
        self.pageManager.textRenderSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-170);
        [self.pageManager paginate];
        self.cacheNextArray = nil;
        self.cacheNextArray = [NSMutableArray array];
        for(int i=0;i<self.pageManager.pageCount;i++)
        {
            [self.cacheNextArray addObject:[self.pageManager stringOfPage:i]];
        }
        self.cacheNextLabel.text = self.cacheNextArray[0];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.cacheNextLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.cacheNextLabel.text.length)];
        self.cacheNextLabel.attributedText = attributedString;
        [self.cacheNextLabel sizeToFit];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络异常"];
    }];
}



//分页并显示
-(void)loadtext:(NSString *)string
{
    NSMutableString *strcache = [NSMutableString stringWithString:string];
    NSMutableString *str = [NSMutableString stringWithFormat:@"\t%@",strcache];
    [str replaceOccurrencesOfString:@"<br /><br />" withString:@"\n\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    self.pageManager = [[E_Paging alloc]init];
    self.pageManager.contentText = str;
    self.pageManager.contentFont = 14;
    self.pageManager.textRenderSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-170);
    [self.pageManager paginate];
    self.textArray = [NSMutableArray array];
    for(int i=0;i<self.pageManager.pageCount;i++)
    {
        [self.textArray addObject:[self.pageManager stringOfPage:i]];
    }

    //设置
    [self setscorller];
}




//设置滚动视图
-(void)setscorller
{
    
    
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroller.backgroundColor = [UIColor clearColor];
    scroller.delegate = self;
    scroller.pagingEnabled = YES;
    scroller.bounces = YES;
    //不显示水平滚动条
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.contentSize = CGSizeMake(SCREEN_WIDTH * (self.pageManager.pageCount+1), self.view.bounds.size.height);
    
    for(int i = 0;i<(self.pageManager.pageCount+1);i++)
        
    {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i+10, 20, SCREEN_WIDTH-20, SCREEN_HEIGHT-30)];
        textLabel.textColor = JSColor(82, 82, 82);
        textLabel.font = [UIFont systemFontOfSize:14.f];
        textLabel.numberOfLines = 0;
//        if(i==0)
//        {
//            if(self.cacheBeforeArray.count>0)
//            {
//                textLabel.text = self.cacheBeforeArray[self.cacheBeforeArray.count-1];
//            }
//            else
//            {
//                textLabel.text = @"\t很抱歉由于网络问题未能获取到该章节，请重试！请重试！请重试！";
//            }
//            self.cacheBeforeLabel = textLabel;
//        }
        if(i<self.pageManager.pageCount)
        {
            textLabel.text = [self.pageManager stringOfPage:i%_pageManager.pageCount];
        }
        else if(i==self.pageManager.pageCount)
        {
            textLabel.text = @"\t很抱歉由于网络问题未能获取到该章节，请重试！请重试！请重试！";
            self.cacheNextLabel = textLabel;
        }
        
        NSLog(@"%@",textLabel.text);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
        textLabel.attributedText = attributedString;
        [textLabel sizeToFit];
        
        [scroller addSubview:textLabel];
    }
    self.lastX = SCREEN_WIDTH;
    
    //从一开始显示
    [scroller setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:scroller];
    self.MainScroller = scroller;
    self.MainScroller.delegate = self;
    
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [self.MainScroller addGestureRecognizer:sigleTapRecognizer];
    
    //去取下一章缓存
    [self getnextChapter];
}

/**
 *  滚动停止
 *
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x/SCREEN_WIDTH == self.textArray.count)
    {
        self.currentChapterIndex+=1;
        [self.MainScroller removeFromSuperview];
        self.cacheBeforeArray = [self.textArray copy];
        self.textArray = nil;
        self.textArray = [NSMutableArray array];
        for(int i=0;i<self.cacheNextArray.count;i++)
        {
            [self.textArray addObject:self.cacheNextArray[i]];
        }
        [self setscorller];
    }
//    else if(scrollView.contentOffset.x == 0)
//    {
//        self.currentChapterIndex-=1;
//        [self.MainScroller removeFromSuperview];
//        self.cacheNextArray = [self.textArray copy];
//        self.textArray = nil;
//        self.textArray = [NSMutableArray array];
//        for(int i=0;i<self.cacheBeforeArray.count;i++)
//        {
//            [self.textArray addObject:self.cacheNextArray[i]];
//        }
//        [self setscorller];
//    }
}





//手势点击事件
-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    CGPoint currentPoint = [tapRecognizer locationInView:self.view];
    if(currentPoint.x<SCREEN_WIDTH*0.25)
    {
        NSLog(@"点了左边");
        CharpterVC *vc = [[CharpterVC alloc]init];
        vc.bookID = self.bookmodel.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(currentPoint.x<SCREEN_WIDTH*0.75&&currentPoint.x > SCREEN_WIDTH*0.25)
    {
        NSLog(@"中间显示菜单");
        [self addCoverView];
    }
    if(currentPoint.x>0.75)
    {
        NSLog(@"右边下一页");
    }
}


-(void)addCoverView
{
    UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:cover];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:cover.frame];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.3;
    [cover addSubview:btn];
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    ReadBottomView *vc = [[ReadBottomView alloc]init];
    vc.delegate = self;
    vc.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    [cover addSubview:vc];
    [UIView animateWithDuration:0.3 animations:^{
        vc.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
    }];
}

-(void)dismiss:(UIButton *)btn
{
    [btn.superview removeFromSuperview];
}

#pragma mark - 底部视图代理方法
-(void)clickButton:(NSInteger)index
{
    if(index == 1)
    {
        self.backImage.image = [UIImage imageNamed:@""];
        self.backImage.backgroundColor = [UIColor whiteColor];
    }
    else if(index == 2)
    {
        self.backImage.image = [UIImage imageNamed:@"bg_btn2"];
    }
    else if(index == 3)
    {
        self.backImage.image = [UIImage imageNamed:@"body_bg4"];
    }
    else if(index == 4)
    {
        self.backImage.image = [UIImage imageNamed:@"body_bg3"];
    }
    else if(index == 5)
    {
        
    }
    else if(index == 6)
    {
        
    }
    else if(index == 7)
    {
        
    }
    else if(index == 8)
    {
        
    }

    
}
//懒加载初始化，在复用数组中有三个imageview
-(NSMutableArray *)LabelsArray
{
    if(!_LabelsArray)
    {
        self.LabelsArray = [NSMutableArray array];
        for(int i =0;i<3;i++)
        {
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i+10, 20, SCREEN_WIDTH-20, SCREEN_HEIGHT-30)];
            textLabel.textColor = JSColor(82, 82, 82);
            [self.LabelsArray addObject:textLabel];
        }
    }
    return _LabelsArray;
}

//懒加载章节array
-(NSMutableArray *)ChapterArray
{
    if(!_ChapterArray)
    {
        _ChapterArray = [NSMutableArray array];
    }
    return _ChapterArray;
}

-(NSMutableArray *)ChaptersRepeatArray
{
    if(!_ChaptersRepeatArray)
    {
        _ChaptersRepeatArray = [NSMutableArray array];
    }
    return _ChaptersRepeatArray;
}
@end
