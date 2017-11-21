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

static NSString *cellId = @"LNImageCollectionViewCell";

@interface ImagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *rectArray;

@end

@implementation ImagesViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 260, kMainScreenWidth, itemWidth) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[LNImageCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    [self nearByNavigationBarView:collectionView isShowBottom:YES];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = kWhiteColor;
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataSource objectAtIndex:indexPath.item]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LNImageCollectionViewCell *cell = (LNImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    // convert rect to self(cell)
    CGRect rectInWindow = [cell convertRect:cell.imageView.frame toView:window];
    
    [LNImageBrowser showBrowserFromRect:rectInWindow andImage:cell.imageView.image];
}

#pragma mark - getter
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    }
    return _dataSource;
}

@end
