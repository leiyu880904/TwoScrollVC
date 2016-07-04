//
//  MyCell.h
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/27.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel1;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end
