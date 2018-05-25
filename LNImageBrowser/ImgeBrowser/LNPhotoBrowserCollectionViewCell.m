//
// Created by 张立宁 on 2018/5/21.
// Copyright (c) 2018 ZLN. All rights reserved.
//

#import "LNPhotoBrowserCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

@interface LNPhotoBrowserCollectionViewCell () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIActivityIndicatorView *activity;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
@property(nonatomic, strong) UITapGestureRecognizer *doubleTap;

@end

@implementation LNPhotoBrowserCollectionViewCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)addViews {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.activity];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.activity.center = self.contentView.center;
}

- (void)reloadWithPlaceholdImage:(UIImage *)placehold andImageUrl:(NSURL *)url {
    [self adjustFrameWithImage:placehold];
    self.imageView.image = placehold;
    [self.activity startAnimating];

    if (!url) {
        [self.activity stopAnimating];
        return;
    }
    [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                options:SDWebImageRetryFailed
                                               progress:nil
                                              completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL *_Nullable imageURL) {
                                                  [self.activity stopAnimating];
                                                  [self.imageView setImage:image];
                                              }];
}

- (void)adjustFrameWithImage:(UIImage *)image {
    [self.scrollView setZoomScale:1.f];
    CGRect frame = self.scrollView.frame;
    if (image) {
        CGSize imageSize = image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);

        CGFloat ratio = frame.size.width / imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height * ratio;
        imageFrame.size.width = frame.size.width;

        self.imageView.frame = imageFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollViewContent:self.scrollView];

        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height / imageFrame.size.height;
        maxScale = frame.size.width / imageFrame.size.width > maxScale ? frame.size.width / imageFrame.size.width : maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        //初始化
        self.scrollView.minimumZoomScale = kMinZoomScale;
        self.scrollView.maximumZoomScale = maxScale;
    }

    self.scrollView.contentOffset = CGPointZero;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
            (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f : 0.0f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
            (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f : 0.0f;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX,
            scrollView.contentSize.height * 0.5f + offsetY);
    return actualCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"scrollViewWillBeginZooming");
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
}

#pragma mark - privaty

- (void)singleTapAction:(UITapGestureRecognizer *)singleGesture {
    if ([self.delegate respondsToSelector:@selector(tapTheImageVeiw:)]) {
        [self.delegate tapTheImageVeiw:self.imageView];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)doubleGesture {

//    float newScale = [self.scrollView zoomScale] * 1.5;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleGesture locationInView:doubleGesture.view]];
//    [self.scrollView zoomToRect:zoomRect animated:YES];
//    return;

    CGPoint touchPoint = [doubleGesture locationInView:self];
    if (self.scrollView.zoomScale <= 1.0) {

//        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;//需要放大的图片的X点
//        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;//需要放大的图片的Y点
//        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        float newScale = [self.scrollView zoomScale] * 1.5;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleGesture locationInView:doubleGesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {

    CGRect zoomRect;

    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;

    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

//- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
//    CGRect zoomRect;
//    zoomRect.size.height = self.frame.size.height / scale;
//    zoomRect.size.width = self.frame.size.width / scale;
//    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0f);
//    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0f);
//    return zoomRect;
//}

#pragma mark - getter

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.singleTap];
        [_imageView addGestureRecognizer:self.doubleTap];
    }
    return _imageView;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

@end
