//
//  ViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "ViewController.h"
#import "ImagesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ImagesViewController *images = [ImagesViewController new];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:images];
    rootNav.navigationBar.hidden = YES;
    [self presentViewController:rootNav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
