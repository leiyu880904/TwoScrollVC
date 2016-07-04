# TwoScrollVC
类似腾讯新闻的Demo
创建TRButton类，继承UIButton，实现按钮拖动动画逻辑。
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
        for (NSInteger num=self.dragIndex-1; num>=index; num—)
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

定义ButtonsView，把创建好的按钮放到ButtonsView排列好。
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
        [button addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.allButtons addObject:button];
        button.btnArray = self.allButtons;
        [self addSubview:button];
        CGFloat height = button.frame.origin.y;
        CGFloat viewHeight = height + 50 + 30 + 40;
        self.frame = CGRectMake(0, 0, WIDTH, viewHeight);
    }

push“ButtonsTableViewController”视图控制器的时候，布局界面

//创建头视图（规矩排列的按钮组）
- (void)createHeaderView
{
    self.buttonsView.buttonTitles = self.buttonTitles;
    self.buttonsView.index = self.isLeft;
    self.buttonsView.buttonTitles1 = @[@"推荐频道",@"地方频道"];
    [self.buttonsView createButtons];
}

首页实现两个滚动视图的交互功能，设计逻辑是：最上面的滚动视图放入按钮数组，最下面的滚动视图加入tableView，滚动的交互实现－－－
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScrollView)
    {
        CGPoint point = self.bottomScrollView.contentOffset;
        //取比率
        CGFloat r = point.x/WIDTH;
        //取整数
        NSInteger n = (NSInteger)point.x/WIDTH;
        self.buttonIndex = n;
        NSLog(@"大滚动视图滚动的距离 = %ld",n);
        //当滚动距离大于0
        if (point.x > 0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                  self.topView.bottomView.frame = CGRectMake(LINEWIGTH * r + 5*(2*n+1), self.topView.myScrollView.frame.size.height - 3, LINEWIGTH, 3);
//                NSLog(@"self.topView.bottomView.frame = %f",self.topView.bottomView.frame.origin.x);
                //当最上方的滚动视图滚动到第5个按钮的时候，需要把最上方的滚动视图向右滚动一段距离，以便第五个按钮看得见
                
                //正在拖拽的时候
                if (self.bottomScrollView.dragging)
                {
                    if (n > 3)
                    {
                        self.topView.myScrollView.contentOffset = CGPointMake(LINEWIGTH * r + 5*(2*n+1), 0);
                    }
                    else
                    {
                        self.topView.myScrollView.contentOffset = CGPointMake(0, 0);
                    }
                }
                for (UIButton* button in self.topView.allButtons)
                {
                    if (button.tag == n)
                    {
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }
                }
            }];
        }
    }
}

如果觉得好的话，可以star一下我的项目，任何好的实现方案及bug，可发我邮箱443465721@qq.com。
