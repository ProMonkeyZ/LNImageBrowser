//
//  LNGCDTimer.h
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/11/21.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^nomalVoidHandler)(dispatch_source_t timer);

@interface LNGCDTimer : NSObject

/**
 开启一个定时器
 
 @param target 定时器持有者
 @param timeInterval 执行间隔时间
 @param handler 重复执行事件
 */
- (void)dispatchTimerWithTarget:(id)target interval:(NSTimeInterval)timeInterval handler:(nomalVoidHandler)handler;

@end
