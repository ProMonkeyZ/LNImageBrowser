//
//  ImagesViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "ImagesViewController.h"
#import "LNImageCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "LNImageBrowser.h"

static NSString *cellId = @"LNImageCollectionViewCell";

@interface ImagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, LNImageBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *rectArray;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property(nonatomic, assign) CGRect currentRect;

@end

@implementation ImagesViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.userInteractionEnabled = NO;
    
    [[SDImageCache sharedImageCache] clearMemory];
    __weak typeof(self) wself = self;
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        __strong typeof(wself) strongSelf = wself;
        strongSelf.collectionView.userInteractionEnabled = YES;
    }];
    
    [self createImageData];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSMutableArray<NSString *> *array = [NSMutableArray<NSString *> array];
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        // 转换坐标系。把cell里图片的参照系从cell换成UIWindow
        CGRect rectInWindow = [cell convertRect:cell.imageView.frame toView:window];
        [array addObject:NSStringFromCGRect(rectInWindow)];
    }
    // rectArray为cell原先位置(以window为参照系)的数组
    self.rectArray = array;
}

- (void)initUI {
    self.navigationBarView.titleLabel.text = @"图片列表";
    
    CGFloat itemWidth = (kMainScreenWidth - 26) / 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.sectionInset = UIEdgeInsetsMake(15, 11, 15, 11);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[LNImageCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    [self nearByNavigationBarView:collectionView isShowBottom:NO];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = kWhiteColor;
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
//    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataSource objectAtIndex:indexPath.item]]];
//    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[self.dataSource objectAtIndex:indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.currentRect = [cell convertRect:cell.imageView.frame toView:window];
    
    [LNImageBrowser showBrowserAtIndex:indexPath.item andImage:cell.imageView.image andDelegate:self];
}

/**
 创建gif分解图片数据
 */
- (void)createImageData {
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Kiss" ofType:@"GIF"]];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    for (int i = 0; i < count; i ++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        CGImageRef clipedImage = CGImageCreateWithImageInRect(image, CGRectMake(10, 10, CGImageGetWidth(image) - 20, CGImageGetHeight(image) - 20));
        
        UIImage *newImage = [UIImage imageWithCGImage:image];
//        UIImage *newImage = [UIImage imageWithCGImage:clipedImage];
        
        [mArray addObject:newImage];
    }
    CFRelease(source);
    
    self.imagesArray = mArray;
}

#pragma mark - LNPhotoBrowserViewControllerDelegate
- (NSInteger)numberOfItemsInBrowser:(LNImageBrowser *)browser {
    return self.dataSource.count;
}

/**
 图片对应的原始位置
 
 @param index 下标
 @return 位置结构体
 */
- (CGRect)oldRectForItemAtIndex:(NSInteger)index {
    LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [cell.imageView convertRect:cell.imageView.bounds toView:window];
    if (!cell) {
        rect.origin.x = window.frame.size.width * .5f;
        rect.origin.y = window.frame.size.height * .5f;
    }
    return rect;
}

- (UIImage *)placeholdImageAtInex:(NSInteger)index {
    LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.imageView.image;
}

- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index {
    return [NSURL URLWithString:[self.dataSource[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
}

#pragma mark - getter
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithObjects:
                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg", nil];
    }
    return _dataSource;
}

@end
