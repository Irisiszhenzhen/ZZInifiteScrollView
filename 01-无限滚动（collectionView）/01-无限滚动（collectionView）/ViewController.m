//
//  ViewController.m
//  01-无限滚动（collectionView）
//
//  Created by iris on 16/3/5.
//  Copyright © 2016年 陈真真. All rights reserved.
//

#import "ViewController.h"
#import "ZZCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

static NSString * const ZZCollectionViewCellID = @"ZZCollectionViewCellID";
static NSInteger ZZItemCount = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) collectionViewLayout:flowLayout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    [self.view addSubview:collectionView];
    
    flowLayout.itemSize = collectionView.frame.size;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZZCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ZZCollectionViewCellID];
    
    // 默认显示最中间的cell
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ZZItemCount / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ZZItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZZCollectionViewCellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_0%zd",indexPath.item % 5 + 1]];
    NSLog(@"%zd",indexPath.item);
    
    return cell;
}

#pragma mark - 代理方法
/** 手指松开的时候调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSInteger item = (ZZItemCount / 2) + (index % 5);
    
    [(UICollectionView *)scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
