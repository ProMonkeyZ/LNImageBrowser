//
//  LNColor.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#ifndef LNColor_h
#define LNColor_h

// 定义通用颜色
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]


#define MAX_LARGE_FONT_SIZE     20

#define LARGE_FONT_SIZE         18

#define MIDDLE_FONT_SIZE        16

#define SMALL_FONT_SIZE         13

#define MIN_FONT_SIZE           11

#define NAVIGATIONBAR_HEIGHT (IsIOS7 ? 65 : 45)

#define TABLE_BAR_HEIGHT   49

#define NodeExist(node) (node != nil && ![node isEqual:[NSNull null]])

#ifdef DEBUG
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)

#else
#define CLog(format, ...)
#endif


#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0? YES : NO)
#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO)
#define IsIOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0? YES : NO)


#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

// 屏幕宽高
#define kMainScreenWidth    ScreenWidth()
#define kMainScreenHeight   ScreenHeight()


static __inline__ CGFloat ScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat ScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

#endif /* LNColor_h */
