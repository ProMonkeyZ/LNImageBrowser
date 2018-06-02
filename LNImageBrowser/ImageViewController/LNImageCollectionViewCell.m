//
//  LNImageCollectionViewCell.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "LNImageCollectionViewCell.h"

@interface LNImageCollectionViewCell()

@end

@implementation LNImageCollectionViewCell

@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
    }
    return self;
}

- (void)addViews {
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
