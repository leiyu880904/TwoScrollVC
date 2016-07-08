//
//  ButtonsTableViewController.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/28.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "ButtonsTableViewController.h"
#import "ButtonsCell.h"
#import "ButtonsView.h"
#import "DataModel.h"
#import "TRButton.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define KONGWIDTH (WIDTH - 4*60)/5

@interface ButtonsTableViewController ()
@property (nonatomic, strong) NSArray* testArray1;
@property (nonatomic, strong) NSArray* testArray2;
@property (nonatomic, unsafe_unretained) NSInteger isLeft;
@property (nonatomic, strong) UIView* view1;
@property (nonatomic, strong) UIView* view2;
@property (nonatomic, strong) ButtonsView* buttonsView;

@property (nonatomic, strong) NSString* myTitle;

@end

@implementation ButtonsTableViewController

- (ButtonsView*)buttonsView
{
    if (!_buttonsView)
    {
        _buttonsView = [[ButtonsView alloc]init];
    }
    return _buttonsView;
}
- (NSArray*)testArray1
{
    if (!_testArray1)
    {
        NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
        _testArray1 = [newsData objectForKey:@"testArray1"];
    }
    return _testArray1;
}
- (NSArray*)testArray2
{
    if (!_testArray2)
    {
        NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
        _testArray2 = [newsData objectForKey:@"testArray2"];
    }
    return _testArray2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"频道定制";
    self.myTitle = [self getTitle];
    [self createHeaderView];
    self.tableView.tableHeaderView = self.buttonsView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goBack)];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonChange:) name:@"buttonChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonChange1:) name:@"buttonChange1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonChange5:) name:@"buttonChange5" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isLeft = 0;
    
}
//创建头视图（规矩排列的按钮组）
- (void)createHeaderView
{
    self.buttonsView.buttonTitles = self.buttonTitles;
    self.buttonsView.index = self.isLeft;
    self.buttonsView.buttonTitles1 = @[@"推荐频道",@"地方频道"];
    [self.buttonsView createButtons];
}
//点击表视图头部的按钮
- (void)buttonChange:(NSNotification*)notification
{
    NSLog(@"点击表视图头部的按钮");
    NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
    TRButton* button = (TRButton*)notification.userInfo[@"button"];
    if ([[DataModel getNewsArray][button.currentTitle][@"type"] isEqualToString:@"推荐"])
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.testArray1];
        [array insertObject:button.currentTitle atIndex:0];
        self.testArray1 = [array copy];
        [newsData setObject:self.testArray1 forKey:@"testArray1"];
        self.isLeft = 0;
    }
    else
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.testArray2];
        [array insertObject:button.currentTitle atIndex:0];
        self.testArray2 = [array copy];
        [newsData setObject:self.testArray2 forKey:@"testArray2"];
        self.isLeft = 1;
    }
    self.buttonsView.index = self.isLeft;
    [self.buttonsView removeAllButtons];
    [self.buttonsView createChannelButton];
    self.buttonTitles = notification.userInfo[@"buttonArray"];
    self.tableView.tableHeaderView = self.buttonsView;
    [self.tableView reloadData];
}

//改变按钮位置 重新排列数组 得到新的数组
- (void)buttonChange5:(NSNotification*)notification
{
    NSLog(@"改变按钮位置 重新排列数组 得到新的数组");
    self.buttonTitles = notification.userInfo[@"buttonArray"];
    self.tableView.tableHeaderView = self.buttonsView;
    [self.tableView reloadData];
}
//点击频道
- (void)buttonChange1:(NSNotification*)notification
{
    self.isLeft = [notification.userInfo[@"buttonTag"] integerValue];
    NSLog(@"点击了哪个频道 %ld",(long)self.isLeft);
    self.tableView.tableHeaderView = self.buttonsView;
    [self.tableView reloadData];
}
- (void)goBack
{
    NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
    [newsData setObject:self.buttonTitles forKey:@"testArray"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeArray" object:self userInfo:@{@"array":self.buttonTitles,@"index":[NSString stringWithFormat:@"%ld",(long)[self getIndex]]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//添加频道
- (void)addData:(UIButton*)sender
{
    [self.buttonsView  removeAllButtons];
    [self.buttonsView removeAllButtons1];
    self.buttonTitles = self.buttonsView.buttonTitles;
    ButtonsCell *cell = (ButtonsCell*)[[sender superview]superview];
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonTitles];
    [array addObject:cell.myLabel.text];
    self.buttonTitles = [array copy];
    [self createHeaderView];
    NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
    //删除行
    if (self.isLeft == 0)
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.testArray1];
        [array removeObject:cell.myLabel.text];
        self.testArray1 = [array copy];
        [newsData setObject:self.testArray1 forKey:@"testArray1"];
    }
    else
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.testArray2];
        [array removeObject:cell.myLabel.text];
        self.testArray2 = [array copy];
        [newsData setObject:self.testArray2 forKey:@"testArray2"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableHeaderView = self.buttonsView;
        [self.tableView reloadData];
    });
}
//刚加载完成的时候得到 上个页面的下标对应的title
- (NSString*)getTitle
{
    NSString* title =  self.buttonTitles[self.buttonIndex];
    return title;
}
//根据按钮的文字 获得在新数组里面的位置
- (NSInteger)getIndex
{
    if ([self.buttonTitles containsObject:self.myTitle])
    {
        NSInteger index = [self.buttonTitles indexOfObject:self.myTitle];
        return index;
    }
    else
    {
        return 0;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isLeft == 0 ? self.testArray1.count : self.testArray2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.isLeft == 0)
    {
        cell.myLabel.text = self.testArray1[indexPath.row];
    }
    else
    {
        cell.myLabel.text = self.testArray2[indexPath.row];
    }
    [cell.myButton addTarget:self action:@selector(addData:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


@end
