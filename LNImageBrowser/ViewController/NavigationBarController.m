//
//  NavagationBarController.m
//  UIDemo
//
//  Created by cyx on 14-10-30.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "NavigationBarController.h"
#import <Masonry/Masonry.h>

@interface NavigationBarController ()<NavigatonBarViewDelegate>

@end

@implementation NavigationBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _navigationBarView = [[NavigatonBarView alloc]initLeftButtonPicNormal:[UIImage imageNamed:@"whitetop_btn_back_normal"] leftButtonPicHighlight:[UIImage imageNamed:@"whitetop_btn_back_highlight"] rightButtonPicNormal:[UIImage imageNamed:@""] rightButtonPicHighlight:[UIImage imageNamed:@""] fontColor:[UIColor whiteColor]];
    _navigationBarView.backgroundColor = kAppMainColor;
    _navigationBarView.backGroundImgeView.image = nil;
    if([self.navigationController.topViewController isKindOfClass:self.class]&&self.navigationController.viewControllers.count == 1)
        _navigationBarView.navagationBarStyle = None_button_show;
    else
        _navigationBarView.navagationBarStyle = Left_button_Show;
    
    _navigationBarView.titleLabel.font = [UIFont boldSystemFontOfSize:MIDDLE_FONT_SIZE];
    _navigationBarView.delegate = self;
    [self.view addSubview:_navigationBarView];
    
    [_navigationBarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(NAVIGATIONBAR_HEIGHT);
    }];
}


- (void)nearByNavigationBarView:(UIView *)tView isShowBottom:(BOOL)bottom
{
    [tView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBarView.mas_bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        if(IsIOS7)
        {
        if(bottom)
            make.bottom.equalTo(self.view.bottom).offset(-TABLE_BAR_HEIGHT);
        else
            make.bottom.equalTo(self.view.bottom);
        }
        else
        {
           make.bottom.equalTo(self.view.bottom);  
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
}

@end
