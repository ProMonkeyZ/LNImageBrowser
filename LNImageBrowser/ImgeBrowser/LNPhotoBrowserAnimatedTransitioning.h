//
//  LNPhotoBrowserAnimatedTransitioning.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/23.
//  Copyright © 2018年 ZLN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNPhotoBrowserAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/// 动画时间
@property (nonatomic, assign) NSTimeInterval duration;

/// 图片原位置
@property (nonatomic, assign) CGRect originFrame;

/// 展示或消失
@property (nonatomic, assign) BOOL presenting;

@end
