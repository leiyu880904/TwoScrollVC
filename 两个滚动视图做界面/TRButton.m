//
//  TRButton.m
//  拖拽排列按钮
//
//  Created by leiyu on 15/8/27.
//  Copyright (c) 2015年 华康集团. All rights reserved.
//

#import "TRButton.h"
#import "DataModel.h"
@interface TRButton ()

#define WIDTH [UIScreen mainScreen].bounds.size.width
//被拖动按钮的下标
@property (nonatomic ,unsafe_unretained) NSInteger dragIndex;
//被拖动按钮的中心点
@property (nonatomic ,unsafe_unretained) CGPoint dragCenter;
//按钮的背景颜色
@property (nonatomic ,strong) UIColor* bgColor;
//所有拖动按钮
@property (nonatomic ,strong) NSMutableArray* dragButtons;
//长安手势刚触碰时的坐标
@property (nonatomic ,unsafe_unretained)CGPoint startPoint;
//准备拖动的按钮开始下标
@property (nonatomic ,unsafe_unretained)NSInteger startIndex;
@property (nonatomic ,strong) UIView* displayView;
@property (nonatomic ,strong) UIButton* topView;
@property (nonatomic ,strong) UIButton* bottomView;

@end
@implementation TRButton
- (instancetype) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        UILongPressGestureRecognizer* longGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongPressed:)];
        [self addGestureRecognizer:longGR];
        [self addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setBtnArray:(NSMutableArray *)btnArray
{
    _btnArray=btnArray;
    for (TRButton* button in btnArray)
    {
        button.dragButtons=btnArray;
    }
}
- (void)changeCount:(TRButton*)sender
{
    NSLog(@"buttons = %ld",(unsigned long)self.dragButtons.count);
    if (self.dragButtons.count > 2)
    {
        //如果按钮数组里面的按钮个数大于2时，可以对其进行删除
        //被点击的按钮的中心点
        self.dragCenter=self.center;
        self.dragIndex=[self.dragButtons indexOfObject:self];
        [self removeButton:self];
        //用于判断对象是否拥有参数提供的方法
        if ([self.delegate respondsToSelector:@selector(dragButton1:buttons:)])
        {
            [self.delegate dragButton1:self buttons:self.dragButtons];
        }
    }
    else
    {
        //如果 只剩下两个频道点击不能删除
        for (UIButton* button in self.dragButtons)
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
    }
}

//调整按钮位置
- (void)removeButton:(UIButton*)dragButton
{
    __block CGPoint oldCenter=self.dragCenter;
    __block CGPoint nextCenter=CGPointZero;
    //将靠后的按钮移动到靠前的位置
    for (NSInteger num=self.dragIndex+1; num<self.dragButtons.count; num++)
    {
        //执行动画过程
        [UIView animateWithDuration:0.2 animations:^{
            UIButton* nextButton=[self.dragButtons objectAtIndex:num];
            nextCenter=nextButton.center;
            nextButton.center=oldCenter;
            oldCenter=nextCenter;
        }];
    }
    self.dragCenter=oldCenter;
    TRButton* button =(TRButton*)[self.dragButtons lastObject];
    //实现被删除按钮的 动画特效
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([[DataModel getNewsArray][self.currentTitle][@"type"] isEqualToString:@"推荐"])
        {
            self.center = CGPointMake((((WIDTH - 2*80)/3) + 80) * 0 + ((WIDTH - 2*80)/3) + 40, button.frame.origin.y + 50 + 30);
        }
        else
        {
            self.center = CGPointMake((((WIDTH - 2*80)/3) + 80) * 1 + ((WIDTH - 2*80)/3) + 40, button.frame.origin.y + 50 + 30);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.dragButtons removeObject:self];
}

//手势响应，判断状态
- (void)buttonLongPressed:(UILongPressGestureRecognizer*)gr
{
    if (gr.state==UIGestureRecognizerStateBegan)
    {
        [self touchesBegan:gr];
    }
    else if (gr.state==UIGestureRecognizerStateChanged)
    {
        [self touchesMoved:gr];
    }
    else
    {
        [self touchesEnded:gr];
    }
}
//拖拽开始的时候
- (void)touchesBegan:(UILongPressGestureRecognizer*)gr
{
    //把指定的子视图移动到顶层
    [[self superview] bringSubviewToFront:self];
    //长安手势刚触碰时的坐标
    self.startPoint = [gr locationInView:self];
    self.bgColor=self.backgroundColor;
    //被拖拽的按钮的中心点
    self.dragCenter=self.center;
    //被拖拽的按钮的下标
    self.dragIndex=[self.dragButtons indexOfObject:self];
    //长按按钮开始时 按钮的下标
    self.startIndex=[self.dragButtons indexOfObject:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform=CGAffineTransformMakeScale(1.2, 1.2);
    }];
}
//拖拽移动过程
- (void)touchesMoved:(UILongPressGestureRecognizer*)gr
{
    // 调整被拖拽按钮的center， 保证它根手指一起滑动
    CGPoint newPoint=[gr locationInView:self];
    CGFloat deltaX=newPoint.x-self.startPoint.x;
    CGFloat deltaY=newPoint.y-self.startPoint.y;
    self.center=CGPointMake(self.center.x+deltaX, self.center.y+deltaY);
    //从所有按钮中一个一个遍历
    for (NSInteger index=0; index<self.dragButtons.count; index++)
    {
        UIButton* button=self.dragButtons[index];
        //如果被拖拽的按钮的下标 不等于遍历的下标
        if (self.dragIndex!=index)
        {
            //如果被拖拽的按钮的中心点 在某个遍历按钮的尺寸内(相当于被拖拽的按钮拖拽移动经过的所有按钮)
            if (CGRectContainsPoint(button.frame, self.center))
            {
                //执行 调换位置(排列顺序)
                [self adjustButton:self index:index];
            }
        }
    }
}
//调整按钮位置
- (void)adjustButton:(UIButton*)dragButton index:(NSInteger)index
{
    //被拖拽的按钮 经过的按钮
    UIButton* moveButton=self.dragButtons[index];
    //被拖拽的按钮 经过的按钮的中心点
    CGPoint moveCenter=moveButton.center;
    //如果要在block内修改block外声明的栈变量，那么一定要对该变量加__block标记：
    __block CGPoint oldCenter=self.dragCenter;
    __block CGPoint nextCenter=CGPointZero;
    //如果经过的按钮的下标 比被拖拽的按钮的下标小
    if (index<self.dragIndex)
    {
        //将靠前的按钮移动到靠后的位置
        for (NSInteger num=self.dragIndex-1; num>=index; num--)
        {
            //执行动画过程
            [UIView animateWithDuration:0.2 animations:^{
                UIButton* nextButton=[self.dragButtons objectAtIndex:num];
                nextCenter=nextButton.center;
                nextButton.center=oldCenter;
                oldCenter=nextCenter;
            }];
        }
        //调整顺序;
        //把拖拽的按钮插入到移动过的按钮的位置
        [self.dragButtons insertObject:dragButton atIndex:index];
        //删除原来拖拽的按钮的位置（因为原来的按钮已经拖拽到其他地方去了，把多余的原来的按钮从数组中去除）
        [self.dragButtons removeObjectAtIndex:self.dragIndex+1];
    }
    //如果经过的按钮的下标 比被拖拽的按钮的下标大
    else
    {
        //将靠后的按钮移动到靠前的位置
        for (NSInteger num=self.dragIndex+1; num<=index; num++)
        {
            //执行动画过程
            [UIView animateWithDuration:0.2 animations:^{
                UIButton* nextButton=[self.dragButtons objectAtIndex:num];
                nextCenter=nextButton.center;
                nextButton.center=oldCenter;
                oldCenter=nextCenter;
            }];
           
        }
        //调整顺序;
        //把拖拽的按钮插入到移动过的按钮的位置
        [self.dragButtons insertObject:dragButton atIndex:index+1];
        //删除原来拖拽的按钮的位置（因为原来的按钮已经拖拽到其他地方去了，把多余的原来的按钮从数组中去除）
        [self.dragButtons removeObjectAtIndex:self.dragIndex];
    }
    self.dragIndex=index;
    self.dragCenter=moveCenter;
}
//拖拽结束的时候
- (void)touchesEnded:(UILongPressGestureRecognizer*)gr
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor=self.bgColor;
        self.transform=CGAffineTransformIdentity;
        self.center=self.dragCenter;
    }];
    // 判断按钮位置是否已经改变，如果发生改变通过代理通知父视图
    if (self.startIndex!=self.dragIndex)
    {
        //用于判断对象是否拥有参数提供的方法   参数示例: @selector(test) or @selector(testById:)
        if ([self.delegate respondsToSelector:@selector(dragButton:buttons:)])
        {
            [self.delegate dragButton:self buttons:self.dragButtons];
        }
    }
}
////CABasicAnimation的代理方法
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if ([[anim valueForKey:@"animationType"] isEqualToString:@"close"])
//    {
//        [self.displayView removeFromSuperview];
//        [self.topView removeFromSuperview];
//        [self.bottomView removeFromSuperview];
//        
//        self.displayView=nil;
//        self.bottomView=nil;
//        self.topView=nil;
//    }
//}

@end
