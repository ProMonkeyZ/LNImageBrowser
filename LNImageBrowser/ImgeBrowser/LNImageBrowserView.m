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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
}

#pragma mark - LNPhotoBrowserCollectionViewCellDelegate

- (void)tapTheImageVeiw:(UIImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(singleTapAtBrowserView:andImageView:)]) {
        [self.delegate singleTapAtBrowserView:self andImageView:imageView];
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

- (void)dealloc {
    NSLog(@"dealloc --- %@",self.class);
}

@end
