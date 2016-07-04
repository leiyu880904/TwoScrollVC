//
//  TitleView.h
//  华康通
//
//  Created by 雷雨 on 16/4/19.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

@property (nonatomic, strong) UIScrollView* myScrollView;
@property (nonatomic, strong) NSArray* buttonTitles;
@property (nonatomic, strong) NSMutableArray* allButtons;
@property (nonatomic, strong) UIView* bottomView;

- (void)scrollView;
- (void)removeScrollView;

@end
