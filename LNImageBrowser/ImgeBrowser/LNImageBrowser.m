//
//  LNImageBrowser.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "LNImageBrowser.h"
#import "LNImageBrowserView.h"

static NSTimeInterval kAnimationDuration = .28;

@interface LNImageBrowser() <LNImageBrowserViewDelegate>

@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) LNImageBrowserView *browserView;
@property(nonatomic, weak) id <LNImageBrowserDelegate> delegate;
// 用来做动画的图片视图
@property(nonatomic, strong) UIImageView *panelImageView;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIImage *currentImage;

@end

@implementation LNImageBrowser

+ (void)showBrowserAtIndex:(NSInteger)index andImage:(UIImage *)image andDelegate:(id<LNImageBrowserDelegate>)delegate {
    LNImageBrowser *browser = [[LNImageBrowser alloc] initWithCurrentIndex:index andCurrentImage:image];
    browser.delegate = delegate;
    [browser show];
}

- (instancetype)initWithCurrentIndex:(NSInteger)index andCurrentImage:(UIImage *)image {
    if (self = [super init]) {
        self.currentIndex = index;
        self.currentImage = image;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.backgroundView];
    [window addSubview:self.browserView];
    [window addSubview:self.panelImageView];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundView.frame = window.bounds;
    CGRect panelImageViewFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(oldRectForItemAtIndex:)]) {
        panelImageViewFrame = [self.delegate oldRectForItemAtIndex:self.currentIndex];
    }
    self.panelImageView.frame = panelImageViewFrame;
    self.panelImageView.image = self.currentImage;
    
    CGSize imageSize = self.currentImage.size;//获得图片的size
    CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    // 图片宽度大于相框宽度,等比例缩放图片,使宽度填充.
    if (imageSize.width > window.bounds.size.width) {
        CGFloat ratio = window.bounds.size.width / imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height * ratio;
        imageFrame.size.width = window.bounds.size.width;
    }
    imageFrame.origin.y = (window.bounds.size.height - imageFrame.size.height) * .5f;
    [UIView animateWithDuration:kAnimationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 1;
                         self.panelImageView.frame = imageFrame;
    } completion:^(BOOL finished) {
        self.browserView.hidden = NO;
        self.panelImageView.hidden = YES;
    }];
}

- (void)hideWithImageView:(UIImageView *)imageView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window resignKeyWindow];
    CGRect panelImageViewFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(oldRectForItemAtIndex:)]) {
        panelImageViewFrame = [self.delegate oldRectForItemAtIndex:self.currentIndex];
    }
    self.panelImageView.frame = imageView.frame;
    self.panelImageView.image = imageView.image;
    self.panelImageView.hidden = NO;
    self.browserView.hidden = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.alpha = 0;
        self.panelImageView.frame = panelImageViewFrame;
    } completion:^(BOOL finished) {
        [self.panelImageView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self.browserView removeFromSuperview];
        self.browserView = nil;
    }];
}

#pragma mrak - LNImageBrowserViewDelegate

- (void)singleTapAtBrowserView:(LNImageBrowserView *)browserView andImageView:(UIImageView *)imageView {
    [self hideWithImageView:imageView];
}

- (NSInteger)numberOfItemsInBrowserView:(LNImageBrowserView *)browserView {
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInBrowser:)]) {
        return [self.delegate numberOfItemsInBrowser:self];
    }
    return 0;
}

- (UIImage *)placeholdImageAtInex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(placeholdImageAtInex:)]) {
        return [self.delegate placeholdImageAtInex:index];
    }
    return nil;
}

- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(highDefinitionImageUrlAtInex:)]) {
        return [self.delegate highDefinitionImageUrlAtInex:index];
    }
    return nil;
}

#pragma mark - getter

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelStatusBar;
        _window.backgroundColor = [UIColor clearColor];
    }
    return _window;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.alpha = 0.2;
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (UIImageView *)panelImageView {
    if (!_panelImageView) {
        _panelImageView = [UIImageView new];
    }
    return _panelImageView;
}

- (LNImageBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[LNImageBrowserView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _browserView.delegate = self;
        _browserView.hidden = YES;
    }
    return _browserView;
}

- (void)dealloc {
    NSLog(@"dealloc --- %@",self.class);
}

@end
