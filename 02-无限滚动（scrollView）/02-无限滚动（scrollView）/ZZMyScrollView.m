//
//  ZZMyScrollView.m
//  02-无限滚动（scrollView）
//
//  Created by iris on 16/3/5.
//  Copyright © 2016年 陈真真. All rights reserved.
//

#import "ZZMyScrollView.h"

@implementation ZZMyScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageControl.frame = CGRectMake((self.frame.size.width - 200) * 0.5, self.frame.size.height - 30, 200, 30);
}

@end
