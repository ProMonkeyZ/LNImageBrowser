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

@interface LNImageBrowser () <LNImageBrowserViewDelegate>

@property(nonatomic, weak) id <LNImageBrowserDelegate> delegate;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) LNImageBrowserView *browserView;
// 用来做动画的图片视图
@property(nonatomic, strong) UIImageView *panelImageView;
@property(nonatomic, strong) UIImage *currentImage;
@property(nonatomic, assign) NSInteger firstIndex;
@property(nonatomic, assign) UIWindowLevel oldLevel;

@end

@implementation LNImageBrowser

+ (void)showBrowserAtIndex:(NSInteger)index andImage:(UIImage *)image andDelegate:(id <LNImageBrowserDelegate>)delegate {
    LNImageBrowser *browser = [[LNImageBrowser alloc] initWithCurrentIndex:index andCurrentImage:image];
    browser.delegate = delegate;
    [browser show];
}

- (instancetype)initWithCurrentIndex:(NSInteger)index andCurrentImage:(UIImage *)image {
    if (self = [super init]) {
        self.firstIndex = index;
        self.currentImage = image;
        self.oldLevel = [[UIApplication sharedApplication] keyWindow].windowLevel;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = UIWindowLevelAlert;
    [window addSubview:self.backgroundView];
    [window addSubview:self.browserView];
    [window addSubview:self.panelImageView];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundView.frame = window.bounds;
    CGRect panelImageViewFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(oldRectForItemAtIndex:)]) {
        panelImageViewFrame = [self.delegate oldRectForItemAtIndex:self.firstIndex];
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
    // ImageView的高度小于屏幕高度时让图片在浏览器中心显示
    if (imageFrame.size.height < window.bounds.size.height) {
        imageFrame.origin.y = (window.bounds.size.height - imageFrame.size.height) * .5f;
    }
    [UIView animateWithDuration:kAnimationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundView.alpha = 1;
                         self.panelImageView.frame = imageFrame;
                     }
                     completion:^(BOOL finished) {
                self.browserView.hidden = NO;
                self.panelImageView.hidden = YES;
            }];
}

- (void)hideWithImageView:(UIImageView *)imageView inScrollView:(UIScrollView *)scrollView {
    __block UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect panelImageViewFrame = imageView.frame;
    if (scrollView.contentOffset.x > 0) {
        panelImageViewFrame.origin.x = -scrollView.contentOffset.x;
    }
    if (scrollView.contentOffset.y > 0) {
        panelImageViewFrame.origin.y = -scrollView.contentOffset.y;
    }
    self.panelImageView.frame = panelImageViewFrame;
    self.panelImageView.image = imageView.image;
    self.panelImageView.hidden = NO;
    self.browserView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(oldRectForItemAtIndex:)]) {
        panelImageViewFrame = [self.delegate oldRectForItemAtIndex:self.browserView.currentIndex];
    } else {
        panelImageViewFrame = CGRectZero;
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.alpha = 0;
        self.panelImageView.frame = panelImageViewFrame;
    } completion:^(BOOL finished) {
        [self.panelImageView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self.browserView removeFromSuperview];
        self.browserView = nil;
        window.windowLevel = self.oldLevel;
    }];
}

#pragma mrak - LNImageBrowserViewDelegate

- (void)singleTapAtBrowserView:(LNImageBrowserView *)browserView andImageView:(UIImageView *)imageView andScrollView:(UIScrollView *)scrollView {
    [self hideWithImageView:imageView inScrollView:scrollView];
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
        _panelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _panelImageView.clipsToBounds = YES;
    }
    return _panelImageView;
}

- (LNImageBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[LNImageBrowserView alloc] initWithFrame:[UIScreen mainScreen].bounds andFirstIndex:self.firstIndex];
        _browserView.delegate = self;
        _browserView.hidden = YES;
    }
    return _browserView;
}

- (void)dealloc {
    NSLog(@"dealloc --- %@", self.class);
}

@end
