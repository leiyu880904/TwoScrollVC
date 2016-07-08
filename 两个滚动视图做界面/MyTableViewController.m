//
//  MyTableViewController.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/27.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyCell.h"
#import "ImageCell.h"
#import "DataModel.h"

@interface MyTableViewController ()<UIScrollViewDelegate>

#define SCROLLVIEWWIDHT ([UIScreen mainScreen].bounds.size.width - 20)
#define SCROLLVIEWHEIGHT self.headerScrollView.frame.size.height

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *firstPageControl;

@end

@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
}

- (void)createScrollView
{
    self.headerScrollView.contentSize =  CGSizeMake(SCROLLVIEWWIDHT * self.scrollViewImageTitles.count, SCROLLVIEWHEIGHT);
    for (int i = 0; i < self.scrollViewImageTitles.count; i++)
    {
        UIButton* button = [[UIButton alloc]init];
        button.tag = i;
        button.frame = CGRectMake(SCROLLVIEWWIDHT * i, 0, SCROLLVIEWWIDHT, SCROLLVIEWHEIGHT);
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:self.scrollViewImageTitles[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerScrollView addSubview:button];
    }
    self.firstPageControl.numberOfPages = self.scrollViewImageTitles.count;
    self.firstPageControl.userInteractionEnabled = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isImage)
    {
        //头视图 是一张图片
        [self.firstPageControl setHidden:YES];
        [self.myImageView setHidden:NO];
        [self.headerScrollView setHidden:YES];
    }
    else
    {
        //头视图 是一个滚动视图
        [self.firstPageControl setHidden:NO];
        [self.myImageView setHidden:YES];
        [self.headerScrollView setHidden:NO];
        [self createScrollView];
    }
    NSLog(@"图片名称 = %@",self.imageTitle);
    self.myImageView.image = [UIImage imageNamed:self.imageTitle];
}

- (void)pushVC:(UIButton*)sender
{
    NSLog(@"滚动视图按钮的tag值%ld",(long)sender.tag);
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.headerScrollView)
    {
        CGPoint point = scrollView.contentOffset;
        self.firstPageControl.currentPage = (NSInteger)point.x/SCROLLVIEWHEIGHT;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.test;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataModel getNewsArray][self.myTitle][@"cell"][indexPath.row] boolValue] ? 140.0 : 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[DataModel getNewsArray][self.myTitle][@"cell"][indexPath.row] boolValue])
    {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.myImageVIew1.image = [UIImage imageNamed:self.imageTitle];
        cell.myImageView2.image = [UIImage imageNamed:self.imageTitle];
        cell.myImageView3.image = [UIImage imageNamed:self.imageTitle];
        return cell;
    }
    else
    {
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.myImageView.image = [UIImage imageNamed:self.imageTitle];
        return cell;
    }
}

@end
