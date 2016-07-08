//
//  ButtonsView.h
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/28.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIView

@property (nonatomic, strong) NSArray* buttonTitles;
@property (nonatomic, strong) NSArray* buttonTitles1;
@property (nonatomic, strong) NSMutableArray* allButtons;
@property (nonatomic, strong) NSMutableArray* allButtons1;
@property (nonatomic, strong) NSMutableArray* views;
//一个判断是哪个按钮被按下的判断值
@property (nonatomic, unsafe_unretained) NSInteger index;

@property (nonatomic, strong) UIButton* moveButton;

- (void)removeAllButtons;
- (void)createButtons;
- (void)removeAllButtons1;
- (void)createChannelButton;

@end
