//
//  LNPhotoBrowserAnimatedTransitioning.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/23.
//  Copyright © 2018年 ZLN. All rights reserved.
//

#import "LNPhotoBrowserAnimatedTransitioning.h"

@implementation LNPhotoBrowserAnimatedTransitioning

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.3;
        self.presenting = YES;
        self.originFrame = CGRectZero;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        // iOS8以上用此方法准确获取
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    
    UIView *pictureView = self.presenting ? toView : fromView;
    CGFloat scaleX = CGRectGetWidth(pictureView.frame) ? CGRectGetWidth(self.originFrame) / CGRectGetWidth(pictureView.frame) : 0;
    CGFloat scaleY = CGRectGetHeight(pictureView.frame) ? CGRectGetHeight(self.originFrame) / CGRectGetHeight(pictureView.frame) : 0;
    CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);
    CGPoint orginCenter = CGPointMake(CGRectGetMidX(self.originFrame), CGRectGetMidY(self.originFrame));
    CGPoint pictureCenter = CGPointMake(CGRectGetMidX(pictureView.frame), CGRectGetMidY(pictureView.frame));;
    
    CGAffineTransform startTransform;
    CGPoint startCenter;
    CGAffineTransform endTransform;
    CGPoint endCenter;
    if (self.presenting) {
        startTransform = transform;
        startCenter = orginCenter;
        endTransform = CGAffineTransformIdentity;
        endCenter = pictureCenter;
    } else {
        startTransform = CGAffineTransformIdentity;
        startCenter = pictureCenter;
        endTransform = transform;
        endCenter = orginCenter;
    }
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toView];
    [container bringSubviewToFront:pictureView];
    
    pictureView.transform = startTransform;
    pictureView.center = startCenter;
    [UIView animateWithDuration:self.duration animations:^{
        pictureView.transform = endTransform;
        pictureView.center = endCenter;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
