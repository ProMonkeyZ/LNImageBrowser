//
//  BaseViewController.h
//  MobileClassPhone
//
//  Created by cyx on 14/11/13.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACViewController.h"

@interface BaseViewController : RACViewController

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
