//
//  ZZInifiteScrollView.h
//  02-无限滚动（scrollView）
//
//  Created by iris on 16/3/5.
//  Copyright © 2016年 陈真真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZInifiteScrollView;

@protocol ZZInifiteScrollViewDelegate <NSObject>

@optional

- (void)inifiteScrollView:(ZZInifiteScrollView *)inifiteScrollView didClickImageAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, ZZInifiteScrollDirection) {
    /** 左右滑动 */
    ZZInifiteScrollDirectionHorizontal = 0,
    /** 上下滑动 */
    ZZInifiteScrollDirectionVertical
};

@interface ZZInifiteScrollView : UIView

/** 图片数据,里面可以存放UIImage对象、NSSTring对象（本地图片名）、NSURL对象（远程图片的URL） */
@property (nonatomic, strong) NSArray *images;
/** 占位图片 */
@property (nonatomic, strong) UIImage *placeholder;
/** 每张图片之间的时间间隔 */
@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, weak, readonly) UIPageControl *pageControl;

/** 滚动方向 */
@property (nonatomic, assign) ZZInifiteScrollDirection scrollDirection;

/** 代理 */
@property (nonatomic, weak) id<ZZInifiteScrollViewDelegate> delegate;

@end
