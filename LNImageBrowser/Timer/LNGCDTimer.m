//
//  LNGCDTimer.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/11/21.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "LNGCDTimer.h"

@implementation LNGCDTimer

- (void)dispatchTimerWithTarget:(id)target
                       interval:(NSTimeInterval)timeInterval
                        handler:(nomalVoidHandler)handler {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(timeInterval *NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(target) weaktarget  = target;
    dispatch_source_set_event_handler(timer, ^{
        if (!weaktarget)  {
            dispatch_source_cancel(timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(timer);
            });
        }
    });
    // 启动定时器
    dispatch_resume(timer);
}

@end
