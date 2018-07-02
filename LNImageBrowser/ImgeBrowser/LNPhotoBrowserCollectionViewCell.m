//
// Created by 张立宁 on 2018/5/21.
// Copyright (c) 2018 ZLN. All rights reserved.
//

#import "LNPhotoBrowserCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import <Photos/Photos.h>

#define kMinZoomScale 1.0f
#define kMaxZoomScale 2.0f

@interface LNPhotoBrowserCollectionViewCell () <UIScrollViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIActivityIndicatorView *activity;

@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
@property(nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property(nonatomic, strong) UITapGestureRecognizer *scrollTap;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;

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
    if ([placehold isKindOfClass:[UIImage class]]) {
        [self adjustFrameWithImage:placehold];
    } else if([placehold isKindOfClass:[NSString class]]) {
        __weak typeof(self) wself = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:(NSString *)placehold] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [wself adjustFrameWithImage:image];
        }];
    }
    if (!url) {
        return;
    }
    
    [self.activity startAnimating];
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [self.activity stopAnimating];
        if (image && !error) {
            [self adjustFrameWithImage:image];
        } else {
            self.imageView.frame = self.scrollView.bounds;
        }
    }];
}

- (void)adjustFrameWithImage:(UIImage *)image {
    if (!image) {
        return;
    }
    [self.scrollView setZoomScale:1.f];
    CGRect scrollFrame = self.scrollView.frame;
    if (image) {
        CGSize imageSize = image.size;//获得图片的size
        
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        // 图片宽度大于相框宽度,等比例缩放图片,使宽度填充.
        if (imageSize.width > scrollFrame.size.width) {
            CGFloat ratio = scrollFrame.size.width / imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height * ratio;
            imageFrame.size.width = scrollFrame.size.width;
        }

        self.imageView.frame = imageFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollViewContent:self.scrollView];

        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = scrollFrame.size.height / imageFrame.size.height;
        maxScale = scrollFrame.size.width / imageFrame.size.width > maxScale ? scrollFrame.size.width / imageFrame.size.width : maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        //初始化
        self.scrollView.minimumZoomScale = kMinZoomScale;
        self.scrollView.maximumZoomScale = maxScale;
    }

    self.scrollView.contentOffset = CGPointZero;
    self.imageView.image = image;
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
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

#pragma mark - privaty

- (void)singleTapAction:(UITapGestureRecognizer *)singleGesture {
    if ([self.delegate respondsToSelector:@selector(tapTheImageVeiw:inScrollView:)]) {
        [self.delegate tapTheImageVeiw:self.imageView inScrollView:self.scrollView];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)doubleGesture {
    if (self.scrollView.zoomScale <= 1.0) {
        
        // 初始化放大倍数为1.5倍
        float ratio = 1.5f;
        if (self.imageView.frame.size.height < self.scrollView.frame.size.height) {
            ratio = self.scrollView.frame.size.height / self.imageView.frame.size.height;
        }
        
        float newScale = [self.scrollView zoomScale] * ratio;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleGesture locationInView:doubleGesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        UIImage *image = self.imageView.image;
        if (!image) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [sheet showInView:self.contentView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self saveImage];
        }
            break;
        case 1: {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)saveImage {
    /*
     同步方法保存图片
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
    } error:&error];
    
    if (error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"图片保存成功";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        });
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = [NSString stringWithFormat:@"图片保存失败,原因:%@",[error.userInfo valueForKey:NSLocalizedDescriptionKey]];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        });
    }
     */
    
    UIImage *image = self.imageView.image;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"图片保存成功";
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                });
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = [NSString stringWithFormat:@"图片保存失败,原因:%@",[error.userInfo valueForKey:NSLocalizedDescriptionKey]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                });
            }
        });
    }];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {

    CGRect zoomRect;

    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;

    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0f);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0f);
    return zoomRect;
}

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
        [_scrollView addGestureRecognizer:self.scrollTap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.singleTap];
        [_imageView addGestureRecognizer:self.doubleTap];
        [_imageView addGestureRecognizer:self.longPress];
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

- (UITapGestureRecognizer *)scrollTap {
    if (!_scrollTap) {
        _scrollTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        _scrollTap.numberOfTapsRequired = 1;
        _scrollTap.numberOfTouchesRequired = 1;
    }
    return _scrollTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        _longPress.minimumPressDuration = .25f;
    }
    return _longPress;
}

@end
