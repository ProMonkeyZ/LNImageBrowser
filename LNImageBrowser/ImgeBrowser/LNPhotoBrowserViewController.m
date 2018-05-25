//
//  LNPhotoBrowserViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/21.
//  Copyright © 2018年 ZLN. All rights reserved.
/**
 让collectionView的实际宽度大于屏幕宽度,并且使itemCell的大小等于屏幕大小,这样就可以实现分页之间有间隙的效果.
 每一个itemCell都存在一个scrollView和一个imageView,
 这样可以实现图片的放大缩小.
 */

#import "LNPhotoBrowserViewController.h"
#import "LNPhotoBrowserCollectionViewCell.h"

#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)

static CGFloat kItemLeftMargin = 4;

static NSString *reuseId = @"LNPhotoBrowserCollectionViewCellReuseId";

@interface LNPhotoBrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate, LNPhotoBrowserCollectionViewCellDelegate>

@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LNPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)addViews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backgroundView.frame = self.view.bounds;

    CGFloat collectionX = -kItemLeftMargin;
    CGFloat collectionY = 0.f;
    CGFloat collectionW = CGRectGetWidth(self.view.bounds) + kItemLeftMargin * 2;
    CGFloat collectionH = CGRectGetHeight(self.view.bounds);
    self.collectionView.frame = CGRectMake(collectionX, collectionY, collectionW, collectionH);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate conformsToProtocol:@protocol(LNPhotoBrowserViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(numberOfItemsInBrowserViewController:)]) {
        return [self.delegate numberOfItemsInBrowserViewController:self];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mrak - getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.alpha = 0.2;
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

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
        _layout.itemSize = self.view.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, kItemLeftMargin, 0, kItemLeftMargin);
        _layout.minimumLineSpacing = kItemLeftMargin * 2;
    }
    return _layout;
}

@end
