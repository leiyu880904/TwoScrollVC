//
//  ButtonsView.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/28.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "ButtonsView.h"
#import "TRButton.h"
#import "ButtonsView_CreateString.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define KONGWIDTH (WIDTH - 4*60)/5

@interface ButtonsView ()<TRButtonDelegate>

@end
@implementation ButtonsView
- (UILabel*)leftLabel
{
    if (!_leftLabel)
    {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(KONGWIDTH, 20, 100, 20)];
        _leftLabel.text = @"已选频道";
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    }
    return _leftLabel;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH -150 - KONGWIDTH, 20, 150, 20)];
        _titleLabel.text = @"按住拖动调整排序";
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    }
    return _titleLabel;
}
- (UIButton*)button1
{
    if (!_button1)
    {
        _button1 = [[UIButton alloc]init];
        _button1.tag = 0;
        [_button1 setTitle:self.buttonTitles1[0] forState:UIControlStateNormal];
        [_button1 setBackgroundColor:[UIColor whiteColor]];
        self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 28, 80, 2)];
        
        self.view1.tag = 0;
        self.view1.backgroundColor = [UIColor orangeColor];
        [self.views addObject:self.view1];
        [self.allButtons1 addObject:_button1];
        [_button1 addSubview:self.view1];
        [_button1 addTarget:self action:@selector(showLeftData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
- (UIButton*)button2
{
    if (!_button2)
    {
        _button2 = [[UIButton alloc]init];
        _button2.tag = 1;
        [_button2 setTitle:self.buttonTitles1[1] forState:UIControlStateNormal];
        [_button2 setBackgroundColor:[UIColor whiteColor]];
        self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 28, 80, 2)];
        self.view2.tag = 1;
        self.view2.backgroundColor = [UIColor orangeColor];
        [self.views addObject:self.view2];
        [self.allButtons1 addObject:_button2];
        [_button2 addSubview:self.view2];
        [_button2 addTarget:self action:@selector(showLeftData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}
- (NSMutableArray*)allButtons
{
    if (!_allButtons)
    {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}
- (NSMutableArray*)allButtons1
{
    if (!_allButtons1)
    {
        _allButtons1 = [NSMutableArray array];
    }
    return _allButtons1;
}
- (NSMutableArray*)views
{
    if (!_views)
    {
        _views = [NSMutableArray array];
    }
    return _views;
}
- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createButtons
{
    [self addSubview:self.leftLabel];
    [self addSubview:self.titleLabel];
    for (int i = 0; i < self.buttonTitles.count; i++)
    {
        //代表第几行
        NSInteger n = (NSInteger)i/4;
        //代表第几列
        NSInteger l = (NSInteger)i%4;
        TRButton* button=[TRButton buttonWithType:UIButtonTypeCustom];
        button.delegate=self;
        button.tag = i;
        button.userInteractionEnabled = YES;
        button.frame = CGRectMake(((KONGWIDTH + 60) * l) + KONGWIDTH, (n * (KONGWIDTH + 30)) + 20 + 40, 60, 30);
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.3;
        button.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        [self.allButtons addObject:button];
        button.btnArray = self.allButtons;
        [self addSubview:button];
        CGFloat height = button.frame.origin.y;
        CGFloat viewHeight = height + 50 + 30 + 40;
        self.frame = CGRectMake(0, 0, WIDTH, viewHeight);
    }
    [self createChannelButton];
}

- (void)createChannelButton
{
    self.button1.frame = CGRectMake((((WIDTH - 2*80)/3) + 80) * 0 + ((WIDTH - 2*80)/3), self.frame.size.height - 30, 80, 30);
    self.button2.frame = CGRectMake((((WIDTH - 2*80)/3) + 80) * 1 + ((WIDTH - 2*80)/3), self.frame.size.height - 30, 80, 30);
    if (self.index == 0)
    {
        [self.button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.view2.hidden = YES;
        self.view1.hidden = NO;
    }
    else
    {
        [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.view2.hidden = NO;
        self.view1.hidden = YES;
    }
    [self addSubview:self.button1];
    [self addSubview:self.button2];
}
//推荐频道和地方频道
- (void)showLeftData:(UIButton*)sender
{
    for (UIView* view in self.views)
    {
        if (view.tag == sender.tag)
        {
            view.hidden = NO;
        }
        else
        {
            view.hidden = YES;
        }
    }
    for (UIButton* button in self.allButtons1)
    {
        if (button.tag == sender.tag)
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonChange1" object:self userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",(long)sender.tag]}];
}

- (void)removeAllButtons1
{
    for (TRButton* button in self.allButtons)
    {
        [button removeFromSuperview];
    }
    [self.allButtons removeAllObjects];
}
- (void)removeAllButtons
{
    for (UIButton* button in self.allButtons1)
    {
        [button removeFromSuperview];
    }
    [self.allButtons1 removeAllObjects];
}
- (void)dragButton1:(TRButton *)button buttons:(NSArray *)buttons
{
    //点击哪个button 删除button
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonTitles];
    [array removeObject:button.currentTitle];
    self.buttonTitles = [array copy];
    for (TRButton* button in self.allButtons)
    {
        CGFloat height = button.frame.origin.y;
        CGFloat viewHeight = height + 50 + 30 + 40;
        self.frame = CGRectMake(0, 0, WIDTH, viewHeight);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonChange" object:self userInfo:@{@"button":button,@"buttonArray":self.buttonTitles}];
}
//得到变化后的按钮数组
- (void)dragButton:(TRButton *)button buttons:(NSArray *)buttons
{
//    self.allButtons = [NSMutableArray arrayWithArray:buttons];
    NSLog(@"buttons = %@",buttons);
    NSString* currentTitle=button.currentTitle;
    NSLog(@"%@位置发生了改变,counts=%lu",currentTitle,(unsigned long)button.tag);
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonTitles];
    if ([buttons containsObject:button])
    {
        NSInteger index = [buttons indexOfObject:button];
        [array removeObjectAtIndex:button.tag];
        [array insertObject:currentTitle atIndex:index];
        self.buttonTitles = [array copy];
        NSLog(@"index = %ld",(long)index);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonChange5" object:self userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",(long)button.tag],@"buttonArray":self.buttonTitles}];
}

@end
