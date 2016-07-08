//
//  TRButton.h
//  拖拽排列按钮
//
//  Created by leiyu on 15/8/27.
//  Copyright (c) 2015年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRButton;
@protocol TRButtonDelegate <NSObject>

- (void) dragButton:(TRButton*)button buttons:(NSArray*)buttons;
- (void) dragButton1:(TRButton *)button buttons:(NSArray *)buttons;

@end

@interface TRButton : UIButton
@property (nonatomic ,strong) id<TRButtonDelegate> delegate;
//存放需要拖拽的按钮数组
@property (nonatomic ,strong) NSMutableArray* btnArray;


@end
