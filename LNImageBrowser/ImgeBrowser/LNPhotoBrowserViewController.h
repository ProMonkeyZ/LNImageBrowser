//
//  LNPhotoBrowserViewController.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2018/5/21.
//  Copyright © 2018年 ZLN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNPhotoBrowserViewController;

@protocol LNPhotoBrowserViewControllerDelegate <NSObject>

- (NSInteger)numberOfItemsInBrowserViewController:(LNPhotoBrowserViewController *)viewController;

- (UIImage *)placeholdImageAtInex:(NSInteger)index;

- (NSURL *)highDefinitionImageUrlAtInex:(NSInteger)index;

@end

@interface LNPhotoBrowserViewController : UIViewController

@property(nonatomic, weak) id <LNPhotoBrowserViewControllerDelegate> delegate;

@end
