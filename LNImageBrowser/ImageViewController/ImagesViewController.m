//
//  ImagesViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "ImagesViewController.h"
#import "LNImageCollectionViewCell.h"
#import "LNImageBrowser.h"
#import "LNPhotoBrowserViewController.h"
#import "LNPhotoBrowserAnimatedTransitioning.h"

static NSString *cellId = @"LNImageCollectionViewCell";

@interface ImagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, LNPhotoBrowserViewControllerDelegate>

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
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataSource objectAtIndex:indexPath.item]]];
//    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.currentRect = [cell convertRect:cell.imageView.frame toView:window];
//    [LNImageBrowser showBrowserFromRect:rectInWindow andImage:cell.imageView.image];

    LNPhotoBrowserViewController *vc = [LNPhotoBrowserViewController new];
    vc.delegate = self;
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:vc animated:YES completion:nil];
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

- (NSInteger)numberOfItemsInBrowserViewController:(LNPhotoBrowserViewController *)viewController {
    return self.dataSource.count;
}

- (UIImage *)placeholdImageAtInex:(NSInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataSource objectAtIndex:index]]];
}

- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index {
    return nil;
}

#pragma mark - getter
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    }
    return _dataSource;
}

@end
