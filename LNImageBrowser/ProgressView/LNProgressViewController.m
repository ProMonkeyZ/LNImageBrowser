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
    
    [self testTextViewMasonry];
    
//    [self initUI];
}

- (void)testTextViewMasonry {
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.height.equalTo(300);
    }];
    
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor redColor];
    [contentView addSubview:textView];
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    UIView *textContentView = [UIView new];
    [textView addSubview:textContentView];
    [textContentView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(textView);
        make.height.equalTo(textView);
        make.center.equalTo(0);
    }];
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    
    [textContentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
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
