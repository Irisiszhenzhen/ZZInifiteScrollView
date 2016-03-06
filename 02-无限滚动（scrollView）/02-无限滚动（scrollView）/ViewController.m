//
//  ViewController.m
//  02-无限滚动（scrollView）
//
//  Created by iris on 16/3/5.
//  Copyright © 2016年 陈真真. All rights reserved.
//

#import "ViewController.h"
#import "ZZInifiteScrollView.h"
#import "ZZMyScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZZInifiteScrollView *scrollView = [[ZZMyScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    
    scrollView.images = @[
                          [NSURL URLWithString:@"http://img5.duitang.com/uploads/item/201405/25/20140525134237_GLhxa.jpeg"],
                          @"img_01",
                          [UIImage imageNamed:@"img_02"],
                          [UIImage imageNamed:@"img_03"],
                          [UIImage imageNamed:@"img_04"],
                          [UIImage imageNamed:@"img_05"]
                          ];
    
    [self.view addSubview:scrollView];
    
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    scrollView.placeholder = [UIImage imageNamed:@"阿狸"];
    
//    scrollView.interval = 3.0;
    
}


@end
