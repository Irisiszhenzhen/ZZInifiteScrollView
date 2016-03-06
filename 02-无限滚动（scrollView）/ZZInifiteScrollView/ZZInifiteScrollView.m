//
//  ZZInifiteScrollView.m
//  02-无限滚动（scrollView）
//
//  Created by iris on 16/3/5.
//  Copyright © 2016年 陈真真. All rights reserved.
//

#import "ZZInifiteScrollView.h"
#import "UIImageView+WebCache.h"

@interface ZZInifiteScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ZZInifiteScrollView

/** scrollView中的UIImageView的数量 */
static NSInteger ZZImageViewCount = 3;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        // 去除弹簧效果
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor greenColor];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // UIImageView
        for (NSInteger i = 0; i < ZZImageViewCount;i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [scrollView addSubview:imageView];
        }
        
        // UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.backgroundColor = [UIColor blueColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        // 定时器的时间间隔
        self.interval = 1.5;
        
        // 滚动方向
        self.scrollDirection = ZZInifiteScrollDirectionHorizontal;
        
        // 占位图片
        self.placeholder = [UIImage imageNamed:@"ZZInifiteScrollView.bundle/placeholder"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfH = self.frame.size.height;
    CGFloat selfW = self.frame.size.width;
    
    // UIScrollView
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(ZZImageViewCount * selfW, 0);
    
    // UIImageView
    for (NSInteger i = 0; i < ZZImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(i * selfW, 0, selfW, selfH);
    }
    
    // UIPageConrol
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 25;
    self.pageControl.frame = CGRectMake(selfW - pageControlW, selfH - pageControlH, pageControlW, pageControlH);
    
    // 更新内容
    [self updateContentAndOffset];
}

/** 更新图片内容和scrollView的偏移量 */
- (void)updateContentAndOffset {
    // 更新imageView上面的内容
    for (NSInteger i = 0; i < ZZImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        // 根据当前页码求出imageIndex
        NSInteger imageIndex = 0;
        if (i == 0) {
            // 左边视图
            imageIndex = self.pageControl.currentPage - 1;
            if (imageIndex == -1) {
                // 显示最后面一张
                imageIndex = self.images.count - 1;
            }
        } else if (i == 1) {
            // 中间的视图
            imageIndex = self.pageControl.currentPage;
        } else if (i == 2) {
            // 右边视图
            imageIndex = self.pageControl.currentPage + 1;
            if (imageIndex == self.images.count) {
                // 显示最前面一张
                imageIndex = 0;
            }
        }
        imageView.tag = imageIndex;
        // 图片数据
        id obj = self.images[imageIndex];
        if ([obj isKindOfClass:[UIImage class]]) {
            // UIImage对象
            imageView.image = obj;
        } else if ([obj isKindOfClass:[NSString class]]) {
            // 本地图片名
            imageView.image = [UIImage imageNamed:obj];
        } else if ([obj isKindOfClass:[NSURL class]]) {
            // 远程图片URL
            [imageView sd_setImageWithURL:obj placeholderImage:self.placeholder];
        }
    }
    
    // 设置scrollView的偏移量
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - 监听点击
/**
 *  图片点击
 */
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(inifiteScrollView:didClickImageAtIndex:)]) {
        [self.delegate inifiteScrollView:self didClickImageAtIndex:tap.view.tag];
    }
}

#pragma mark - setter
- (void)setImages:(NSArray *)images {
    _images = images;
    
    // 总页数
    self.pageControl.numberOfPages = images.count;
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    
    [self stopTimer];
    [self startTimer];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 找出显示在最中间的imageView
    UIImageView *middleImageView = nil;
    // x值和偏移量x的最小差值
    CGFloat minDelta = MAXFLOAT;
    for (NSInteger i = 0; i < ZZImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        // x值和偏移量x差值最小的imageView，就是显示在最终将的imageView
        CGFloat currentDelta = ABS(imageView.frame.origin.x - self.scrollView.contentOffset.x);
        if (currentDelta < minDelta) {
            minDelta = currentDelta;
            middleImageView = imageView;
        }
    }
    self.pageControl.currentPage = middleImageView.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateContentAndOffset];
}

/** 用户即将开始拖拽的时候调用 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

/** 用户手松开的时候调用 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - 定时器
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(2 * self.scrollView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self updateContentAndOffset];
    }];
}


@end
