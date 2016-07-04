//
//  TRButton.h
//  拖拽排列按钮
//
//  Created by leiyu on 15/8/27.
//  Copyright (c) 2015年 华康集团. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DisplayComletionBlock)(void);
typedef void (^DisplayCloseBlock)(UIView* displayView,CFTimeInterval duration);
typedef void (^DisplayOpenBlock)(UIView* displayView,CFTimeInterval duration);

@class TRButton;
@protocol TRButtonDelegate <NSObject>

- (void) dragButton:(TRButton*)button buttons:(NSArray*)buttons;

@end

@interface TRButton : UIButton
@property (nonatomic ,strong) id<TRButtonDelegate> delegate;
//存放需要拖拽的按钮数组
@property (nonatomic ,strong) NSMutableArray* btnArray;
//按钮正在被拖拽移动时的背景颜色
@property (nonatomic ,strong) UIColor* color;
//一排按钮的个数，如果使用openDisplayView方法，lineCount不能为空
@property (nonatomic ,unsafe_unretained) NSUInteger lineCount;



@end
