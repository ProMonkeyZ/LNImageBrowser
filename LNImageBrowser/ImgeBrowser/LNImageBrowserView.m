//
//  LNImageBrowserView.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/25.
//  Copyright © 2018年 ZLN. All rights reserved.
//

#import "LNImageBrowserView.h"
#import "LNPhotoBrowserCollectionViewCell.h"

#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)

static CGFloat kItemLeftMargin = 4;

static NSString *reuseId = @"LNPhotoBrowserCollectionViewCellReuseId";

@interface LNImageBrowserView () <UICollectionViewDataSource, UICollectionViewDelegate, LNPhotoBrowserCollectionViewCellDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LNImageBrowserView

@synthesize currentIndex = _currentIndex;

- (instancetype)initWithFrame:(CGRect)frame andFirstIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = index;
        [self addViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat collectionX = -kItemLeftMargin;
    CGFloat collectionY = 0.f;
    CGFloat collectionW = CGRectGetWidth(self.bounds) + kItemLeftMargin * 2;
    CGFloat collectionH = CGRectGetHeight(self.bounds);
    self.collectionView.frame = CGRectMake(collectionX, collectionY, collectionW, collectionH);
    
    // 布局完成后,设置偏移量为第一次设定的页码
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * collectionW, 0)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate conformsToProtocol:@protocol(LNImageBrowserViewDelegate)] && [self.delegate respondsToSelector:@selector(numberOfItemsInBrowserView:)]) {
        return [self.delegate numberOfItemsInBrowserView:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LNPhotoBrowserCollectionViewCell class]]) {
        UIImage *placehold = [self.delegate placeholdImageAtInex:indexPath.item];
        NSURL *url = [self.delegate highDefinitionImageUrlAtInex:indexPath.item];
        [(LNPhotoBrowserCollectionViewCell *)cell reloadWithPlaceholdImage:placehold andImageUrl:url];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint contentOffset = [scrollView contentOffset];
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    NSInteger pageNum = contentOffset.x / pageWidth;
    NSLog(@"%ld",(long)pageNum);
    self.currentIndex = pageNum;
}

#pragma mark - LNPhotoBrowserCollectionViewCellDelegate

- (void)tapTheImageVeiw:(UIImageView *)imageView inScrollView:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(singleTapAtBrowserView:andImageView:andScrollView:)]) {
        [self.delegate singleTapAtBrowserView:self andImageView:imageView andScrollView:scrollView];
    }
}

#pragma mrak - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LNPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = self.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, kItemLeftMargin, 0, kItemLeftMargin);
        _layout.minimumLineSpacing = kItemLeftMargin * 2;
    }
    return _layout;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
}

- (NSInteger)currentIndex {
    return _currentIndex;
}

- (void)dealloc {
    NSLog(@"dealloc --- %@",self.class);
}

@end
