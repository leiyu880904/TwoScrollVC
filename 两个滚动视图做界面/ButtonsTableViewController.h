//
//  ButtonsTableViewController.h
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/28.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray* buttonTitles;
@property (nonatomic, unsafe_unretained) NSInteger buttonIndex;

@end
