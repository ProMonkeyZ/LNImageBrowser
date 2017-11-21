//
//  LNImageBrowser.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "LNImageBrowser.h"

@interface LNImageBrowser()

@property (nonatomic, assign) CGRect oldRect;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation LNImageBrowser

+ (void)showBrowserFromRect:(CGRect)oldRect andImage:(UIImage *)image {
    LNImageBrowser *browser = [[LNImageBrowser alloc] initWithOldRect:oldRect andImage:image];
    [browser show];
}

- (instancetype)initWithOldRect:(CGRect)rect andImage:(UIImage *)image {
    if (self = [super init]) {
        self.oldRect = rect;
        self.image = image;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self];
    self.frame = keyWindow.frame;
    
    UIView *contentView = [UIView new];
    self.contentView = contentView;
    contentView.alpha = 0;
    contentView.backgroundColor = kBlackColor;
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.oldRect];
    imageView.userInteractionEnabled = YES;
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    self.imageView = imageView;
}

- (void)show {
    float scale = self.image.size.width / self.image.size.height;
    CGFloat height = kMainScreenWidth / scale;
    [UIView animateWithDuration:.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = .5f;
        self.imageView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:.28 animations:^{
        self.imageView.frame = self.oldRect;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
