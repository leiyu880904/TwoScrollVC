//
//  MainViewController.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/27.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "MainViewController.h"
#import "TitleView.h"
#import "MyTableViewController.h"
#import "ButtonsTableViewController.h"
#import "DataModel.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define LINEWIGTH ((WIDTH/5) - 10)
#define TOPVIEWWIGTH self.topView.frame.size.width

@interface MainViewController ()<UIScrollViewDelegate>
//最上面的滚动视图
@property (nonatomic, strong) TitleView* topView;
//最下面的滚动视图
@property (nonatomic, strong) UIScrollView* bottomScrollView;
@property (nonatomic, strong) NSArray* titles;

//数组保存滚动视图里面的控制器
@property (nonatomic, strong) NSArray* views;
//表视图的表格形式和行数
//@property (nonatomic, strong) NSArray* cellStatus;
//记录滚动视图的按钮位置
@property (nonatomic, unsafe_unretained) NSInteger buttonIndex;
//直接点击滚动视图中的按钮 和 滑动两种状态下
//@property (nonatomic, unsafe_unretained) BOOL isScroll;

@end

@implementation MainViewController


- (NSArray*)titles
{
    if (!_titles)
    {
        _titles = @[@"广州",@"深圳",@"纪录片",@"财经",@"娱乐",@"要闻",@"体育",@"汽车",@"图片",@"科技",@"社会",@"读科学"];
    }
    return _titles;
}
- (TitleView*)topView
{
    if (!_topView)
    {
        _topView = [[TitleView alloc]initWithFrame:CGRectMake(2, 0, WIDTH - 50, 40)];
        _topView.myScrollView.delegate = self;
        _topView.backgroundColor = [UIColor clearColor];
     }
    return _topView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 关闭系统自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonChange3:) name:@"buttonChange3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeArray:) name:@"ChangeArray" object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.topView.buttonTitles = self.titles;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.titleView = self.topView;
    [self.topView scrollView];
    [self createScrollView];
    [self showDurationForView];
}
- (void)changeArray:(NSNotification*)notification
{
    [self.topView removeScrollView];
    self.titles = notification.userInfo[@"array"];
    self.buttonIndex = [notification.userInfo[@"index"] integerValue];
    [self createScrollView];
}
//创建主滚动视图
- (void)createScrollView
{
//    self.imageTitles = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.png",@"7.jpg",@"8.png",@"9.jpg",@"10.jpg",@"11.jpg",@"12.png"];
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.bottomScrollView.scrollsToTop = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.contentSize = CGSizeMake(self.titles.count * WIDTH, HEIGHT - 64);
    self.bottomScrollView.userInteractionEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.scrollEnabled = YES;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i<self.titles.count; i++)
    {
        MyTableViewController* myVC = [[MyTableViewController alloc]initWithNibName:@"MyTableViewController" bundle:nil];
        //设置tag值 以便于在通知里面刷新表格
        myVC.view.tag = i;
        myVC.myTitle = self.titles[i];
        //表视图上面图片的名称
        myVC.imageTitle = [DataModel getNewsArray][self.titles[i]][@"image"];
        //表视图的行数
        myVC.test = [[DataModel getNewsArray][self.titles[i]][@"cell"] count];
        myVC.isImage = [[DataModel getNewsArray][self.titles[i]][@"isImage"] boolValue];
        myVC.scrollViewImageTitles = @[@"11.jpg",@"12.png",@"3.jpg"];
        // 在一个界面中，如果出现多个滚动视图或其子类，则scrollsToTop点击状态栏返回顶部将会失效，解决办法就是将其他滚动视图的scrollsToTop置为NO；
        myVC.tableView.scrollsToTop = NO;
        [self addChildViewController:myVC];
        myVC.view.frame = CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT - 64);
        [array addObject:myVC];
        [self.bottomScrollView addSubview:myVC.view];
    }
    self.views = [array copy];
    [self.view addSubview:self.bottomScrollView];
}
//增加栏目
- (void)add
{
    ButtonsTableViewController* buttonsVC = [[ButtonsTableViewController alloc]initWithNibName:@"ButtonsTableViewController" bundle:nil];
    buttonsVC.buttonTitles = self.titles;
    buttonsVC.buttonIndex = self.buttonIndex;
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:buttonsVC];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)showDurationForView
{
    
    CGPoint point = self.bottomScrollView.contentOffset;
    point.x = self.buttonIndex * WIDTH;
    self.bottomScrollView.contentOffset = point;
    //取比率
    CGFloat r = point.x/WIDTH;
    if (self.buttonIndex > 3)
    {
        self.topView.myScrollView.contentOffset = CGPointMake(LINEWIGTH * r + 5*(2*self.buttonIndex+1), 0);
    }
    else
    {
        self.topView.myScrollView.contentOffset = CGPointMake(0, 0);
    }
}
//点击最上面滚动视图 改变下面滚动视图的变化
- (void)buttonChange3:(NSNotification*)notification
{
    NSInteger index = [notification.userInfo[@"buttonTag"] integerValue];
    self.buttonIndex = index;
    CGPoint point = self.bottomScrollView.contentOffset;
    point.x = index * WIDTH;
    self.bottomScrollView.contentOffset = point;
    for (MyTableViewController* vc in self.views)
    {
        if (vc.view.tag == index)
        {
            [vc.tableView reloadData];
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScrollView)
    {
        CGPoint point = self.bottomScrollView.contentOffset;
        //取比率
        CGFloat r = point.x/WIDTH;
        //取整数
        NSInteger n = (NSInteger)point.x/WIDTH;
        self.buttonIndex = n;
        NSLog(@"大滚动视图滚动的距离 = %ld",n);
        //当滚动距离大于0
        if (point.x > 0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                  self.topView.bottomView.frame = CGRectMake(LINEWIGTH * r + 5*(2*n+1), self.topView.myScrollView.frame.size.height - 3, LINEWIGTH, 3);
//                NSLog(@"self.topView.bottomView.frame = %f",self.topView.bottomView.frame.origin.x);
                //当最上方的滚动视图滚动到第5个按钮的时候，需要把最上方的滚动视图向右滚动一段距离，以便第五个按钮看得见
                
                //正在拖拽的时候
                if (self.bottomScrollView.dragging)
                {
                    if (n > 3)
                    {
                        self.topView.myScrollView.contentOffset = CGPointMake(LINEWIGTH * r + 5*(2*n+1), 0);
                    }
                    else
                    {
                        self.topView.myScrollView.contentOffset = CGPointMake(0, 0);
                    }
                }
                for (UIButton* button in self.topView.allButtons)
                {
                    if (button.tag == n)
                    {
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }
                }
            }];
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

@end
