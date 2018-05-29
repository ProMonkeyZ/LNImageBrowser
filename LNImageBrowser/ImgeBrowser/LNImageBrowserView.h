//
//  LNImageBrowserView.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/25.
//  Copyright © 2018年 ZLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNImageBrowserView;

@protocol LNImageBrowserViewDelegate <NSObject>

/**
 单击图片回调

 @param browserView 代理调用方
 @param imageView 单击视图
 */
- (void)singleTapAtBrowserView:(LNImageBrowserView *)browserView andImageView:(UIImageView *)imageView;

/**
 数据源个数

 @param browserView 代理调用方
 @return 数量
 */
- (NSInteger)numberOfItemsInBrowserView:(LNImageBrowserView *)browserView;

/**
 占位图

 @param index 位置
 @return 图片实例
 */
- (UIImage *)placeholdImageAtInex:(NSInteger)index;

/**
 高清图地址

 @param index 位置
 @return 链接实例
 */
- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index;

@end

@interface LNImageBrowserView : UIView

@property(nonatomic, strong) id <LNImageBrowserViewDelegate> delegate;

@end
