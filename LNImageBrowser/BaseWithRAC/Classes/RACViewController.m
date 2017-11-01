//
//  BaseViewController.m
//  MobileClassPhone
//
//  Created by cyx on 14/11/13.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "RACViewController.h"

@interface RACViewController ()

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self dl_addView];
    [self dl_bindSigal];
}

- (void)dl_addView
{
    

}

- (void)dl_bindSigal
{
    
}


- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

@end
