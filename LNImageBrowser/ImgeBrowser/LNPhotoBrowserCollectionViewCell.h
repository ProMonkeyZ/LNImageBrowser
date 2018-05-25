//
// Created by 张立宁 on 2018/5/21.
// Copyright (c) 2018 ZLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNPhotoBrowserCollectionViewCellDelegate <NSObject>

- (void)tapTheImageVeiw:(UIImageView *)imageView;

@end

@interface LNPhotoBrowserCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) id <LNPhotoBrowserCollectionViewCellDelegate> delegate;

- (void)reloadWithPlaceholdImage:(UIImage *)placehold andImageUrl:(NSURL *)url;

@end
