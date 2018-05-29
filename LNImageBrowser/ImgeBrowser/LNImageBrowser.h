//
//  LNImageBrowser.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNImageBrowser;

@protocol LNImageBrowserDelegate <NSObject>

- (NSInteger)numberOfItemsInBrowser:(LNImageBrowser *)browser;

/**
 图片对应的原始位置

 @param index 下标
 @return 位置结构体
 */
- (CGRect)oldRectForItemAtIndex:(NSInteger)index;

- (UIImage *)placeholdImageAtInex:(NSInteger)index;

- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index;

@end

@interface LNImageBrowser : NSObject

+ (void)showBrowserAtIndex:(NSInteger)index andImage:(UIImage *)image andDelegate:(id <LNImageBrowserDelegate>)delegate;

@end
