//
//  AppDelegate.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/27.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+SelfColor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //建立两个新闻数组 并永久储存
    NSUserDefaults* newsData = [NSUserDefaults standardUserDefaults];
    NSArray* array = @[@"佛学",@"军事",@"电竞",@"电视剧",@"纪录片",@"财经",@"娱乐",@"要闻",@"体育",@"汽车",@"图片",@"科技",@"社会"];
    NSArray* array1 = @[@"时尚",@"游戏",@"房产",@"数码",@"股票",@"国际",@"教育",@"读科学"];
    NSArray* array2 = @[@"重庆",@"四川",@"上海",@"陕西",@"山东",@"浙江",@"湖北",@"河南",@"湖南",@"福建",@"江苏",@"北京",@"广州",@"深圳"];
    [newsData setObject:array forKey:@"testArray"];
    [newsData setObject:array1 forKey:@"testArray1"];
    [newsData setObject:array2 forKey:@"testArray2"];
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor getColor:@"EF7000"]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
