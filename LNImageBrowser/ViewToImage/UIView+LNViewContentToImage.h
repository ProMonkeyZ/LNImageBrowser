//
//  UIView+LNViewContentToImage.h
//  LNImageBrowser
//
//  Created by ZLN on 2019/3/19.
//  Copyright © 2019年 ZLN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LNViewContentToImage)

- (void)shotTheViewToImage:(void(^)(UIImage *image))imageBlock;

@end

NS_ASSUME_NONNULL_END
