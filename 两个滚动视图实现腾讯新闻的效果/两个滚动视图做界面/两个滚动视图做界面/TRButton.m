//
//  TRButton.m
//  拖拽排列按钮
//
//  Created by leiyu on 15/8/27.
//  Copyright (c) 2015年 华康集团. All rights reserved.
//

#import "TRButton.h"
@interface TRButton ()
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
@property (nonatomic ,strong) DisplayOpenBlock openBlock;
@property (nonatomic ,strong) DisplayCloseBlock closeBlock;
@property (nonatomic ,strong) DisplayComletionBlock comletionBlock;

@end
@implementation TRButton
- (instancetype) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        UILongPressGestureRecognizer* longGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongPressed:)];
        [self addGestureRecognizer:longGR];
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
        self.backgroundColor=self.color ? self.color : self.bgColor;
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

//打开动画 开启动画
- (void)openAnimationWithDeltay:(CGFloat)deltay buttonOffset:(CGFloat)buttonOffset height:(CGFloat)height
{
    // 获取当前点击所在的行
    NSUInteger line = self.dragIndex / self.lineCount + 1;
    NSUInteger count = self.lineCount * line;
    
    // 设置上下阴影的动画
    CABasicAnimation *topAnimation = [self positionMoveBasicAnimationFromValue:buttonOffset toValue:-deltay];
    [self.topView.layer addAnimation:topAnimation forKey:@"top1"];
    
    CABasicAnimation *bottomAnimation = [self positionMoveBasicAnimationFromValue:0 toValue:height - deltay];
    [self.bottomView.layer addAnimation:bottomAnimation forKey:@"bottom1"];
    
    // 设置上下按钮动画
    CABasicAnimation *topDragAnimation = [self positionMoveBasicAnimationFromValue:0 toValue:-deltay - buttonOffset];
    NSUInteger maxCount = count < self.dragButtons.count ? count : self.dragButtons.count;
    for (NSUInteger index = 0; index < maxCount; index ++)
    {
        TRButton *dragBtn = self.dragButtons[index];
        [dragBtn.layer addAnimation:topDragAnimation forKey:@"topDrag1"];
    }
    
    CABasicAnimation *bottomDragAnimation = [self positionMoveBasicAnimationFromValue:0 toValue:height - deltay - buttonOffset];
    for (NSUInteger index = self.dragButtons.count - 1; index >= count; index --)
    {
        TRButton *dragBtn = self.dragButtons[index];
        [dragBtn.layer addAnimation:bottomDragAnimation forKey:@"bottomDrag1"];
    }
}
- (UIButton*)buttonForRect:(CGRect)rect position:(CGFloat)positon
{
    UIButton* button=[[UIButton alloc]initWithFrame:rect];
    button.backgroundColor=[UIColor whiteColor];
    button.alpha=0;
    [button addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//关闭动画
- (void)performClose:(UIButton*)sender
{
    CGFloat height=CGRectGetHeight(self.displayView.frame);
    CGFloat position=CGRectGetMaxY(self.frame);
    CGFloat offsetY=0.0;
    //检查父视图是否为UIScrollView
    if ([[self superview] isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* scrollView=(UIScrollView*)self.superview;
        offsetY=scrollView.contentOffset.y;
        position=position-offsetY;
    }
    //检查点击的按钮是否全部在屏幕之中
    CGFloat buttonOffset=0.0;
    if (position-self.superview.frame.size.height>0)
    {
        //此时position就是屏幕的高度
        position=position-buttonOffset;
    }
    
    //屏幕不够显示displayView时，按钮向上偏移值
    CGFloat deltay=0.0;
    if (position+height>self.superview.frame.size.height)
    {
        deltay=height-(self.superview.frame.size.height-position);
    }
    
    //关闭动画
    [self closeAnimationWithDeltaY:deltay buttonOffset:buttonOffset height:height];
    //半透明变透明
    [UIView animateWithDuration:0.2 animations:^{
        self.topView.alpha=0.0;
        self.bottomView.alpha=0.0;
        self.displayView.alpha=0.0;
    }];
    
    if (self.closeBlock)
    {
        self.closeBlock(self.displayView,0.2);
    }
    
}
//关闭动画
- (void)closeAnimationWithDeltaY:(CGFloat)deltay buttonOffset:(CGFloat)buttonOffset height:(CGFloat)height
{
    NSUInteger line=self.dragIndex/self.lineCount+1;
    NSUInteger count=self.lineCount*line;
    NSUInteger maxCount=count<self.dragButtons.count ? count : self.dragButtons.count;
    CGFloat fromValue=height-deltay;
    //关闭上下button动画
    CABasicAnimation* topDragAnimation=[self positionMoveBasicAnimationFromValue:-deltay-buttonOffset toValue:0];
    for (NSUInteger index=0; index<maxCount; index++)
    {
        TRButton* dragButton=self.dragButtons[index];
        [dragButton.layer addAnimation:topDragAnimation forKey:@"topDrag2"];
    }
    
    CABasicAnimation* bottomDragAnimation=[self positionMoveBasicAnimationFromValue:fromValue-buttonOffset toValue:0];
    for (NSUInteger index=self.dragButtons.count-1; index>=count; index--)
    {
        TRButton* dragButton=self.dragButtons[index];
        [dragButton.layer addAnimation:bottomDragAnimation forKey:@"bottomDrag2"];
    }
    
    //关闭阴影动画
    CABasicAnimation* topAnimation=[self positionMoveBasicAnimationFromValue:-deltay toValue:0];
    [self.topView.layer addAnimation:topAnimation forKey:@"top2"];
    
    CABasicAnimation* bottomAnimation=[self positionMoveBasicAnimationFromValue:fromValue toValue:0];
    //设置一个字典的形式 方便在动画的代理方法里执行一些事件
    [bottomAnimation setValue:@"close" forKey:@"animationType"];
    bottomAnimation.delegate=self;
    [self.bottomView.layer addAnimation:bottomAnimation forKey:@"base"];
}
//位移动画
- (CABasicAnimation*)positionMoveBasicAnimationFromValue:(CGFloat)value1 toValue:(CGFloat)value2
{
    CABasicAnimation* position=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //动画时间
    position.duration=0.4;
    //动画速率
    position.speed=1.1;
    //动画效果 （先快后慢 还是先慢后快）
    position.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    position.fromValue=@(value1);
    position.toValue=@(value2);
    //设置动画执行完毕之后不删除动画
    position.removedOnCompletion=NO;
    //设置保存动画的最新状态
    position.fillMode=kCAFillModeForwards;
    return position;
}
//CABasicAnimation的代理方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationType"] isEqualToString:@"close"])
    {
        [self.displayView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.bottomView removeFromSuperview];
        
        self.displayView=nil;
        self.bottomView=nil;
        self.topView=nil;
//只要满足条件一直重复执行block块
        if (self.comletionBlock)
        {
            self.comletionBlock();
        }
    }
}

@end
