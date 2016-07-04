//
//  MyTableViewController.h
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/27.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewController : UITableViewController

@property (nonatomic, strong) NSString* imageTitle;
//测试行数
@property (nonatomic, unsafe_unretained) NSInteger test;

@property (nonatomic, unsafe_unretained) BOOL isImage;
//按钮标题
@property (nonatomic, strong) NSString* myTitle;

@property (nonatomic, strong) NSArray* scrollViewImageTitles;

@end
