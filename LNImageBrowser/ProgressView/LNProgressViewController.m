//
//  LNProgressViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/11/8.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "LNProgressViewController.h"

@interface LNProgressViewController ()

@end

@implementation LNProgressViewController

{
    
    UIProgressView *proView;
    
    float proValue;
    
    NSTimer *timer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    UIProgressView *progressView = [UIProgressView new];
    [self.view addSubview:progressView];
    [progressView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kMainScreenWidth - 20);
        make.height.equalTo(4);
        make.center.equalTo(0);
    }];
    progressView.progressViewStyle = UIProgressViewStyleBar;
    progressView.progressTintColor = [UIColor redColor];
    proView = progressView;
    
    proValue=0;
    
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.003 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self changeProgress];
        }];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:.003 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    }
}

-(void)changeProgress
{
    proValue += 0.0001; // 改变proValue的值
    
    if(proValue == 1)
    {
         //停用计时器
        [timer invalidate];
    }
    else
    {
        [proView setProgress:proValue animated:YES];//重置进度条
    }
    
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
}

@end
