//
//  TitleView.m
//  华康通
//
//  Created by 雷雨 on 16/4/19.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "TitleView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@implementation TitleView


- (NSMutableArray*)allButtons
{
    if (!_allButtons)
    {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}

//更新表格
- (void)changeData:(UIButton*)sender
{
    for (UIButton* button in self.allButtons)
    {
        if (button.tag == sender.tag)
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [self animationForViewWithButton:sender withTag:sender.tag];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonChange3" object:self userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",(long)sender.tag],@"buttonArray":self.allButtons}];
}
- (void)scrollView
{
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    self.myScrollView.contentSize = CGSizeMake(self.buttonTitles.count * SCREENWIDTH / 5, self.frame.size.height);
    self.myScrollView.userInteractionEnabled = YES;
    self.myScrollView.bounces = YES;
    self.myScrollView.scrollEnabled = YES;
    self.myScrollView.pagingEnabled = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    for (int i = 0; i<self.buttonTitles.count; i++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREENWIDTH/5 * i, 0, SCREENWIDTH/5, self.myScrollView.frame.size.height);
        [button addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i == 0)
        {
            self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(5, button.frame.size.height - 3, button.frame.size.width - 10, 3)];
            self.bottomView.backgroundColor = [UIColor orangeColor];
            [button addSubview:self.bottomView];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
//        UIView* view2 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width - 0.5, 13, 0.5, button.frame.size.height - 26)];
//        view2.backgroundColor = [UIColor whiteColor];
//        [button addSubview:view2];
        [self.allButtons addObject:button];
        [self.myScrollView addSubview:button];
    }
    //        NSLog(@"%@",self.buttons);
    [self addSubview:self.myScrollView];
}
- (void)animationForViewWithButton:(UIButton*)button withTag:(NSInteger)tag
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake((button.frame.size.width - 10) * tag + 5*(2*tag+1), button.frame.size.height - 3, button.frame.size.width - 10, 3);
    }];
}
- (void)removeScrollView
{
    [self.myScrollView removeFromSuperview];
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
