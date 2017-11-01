//
//  NavigatonBarView.h
//  forum
//
//  Created by cyx on 12-7-26.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _NavigationBarStyle{
    None_button_show = 0,   //左右都不显示
    Left_button_Show,       //左边显示
    Right_button_show,      //右边显示
    Left_right_button_show  //左右都显示
}NavigationBarStyle;


@protocol NavigatonBarViewDelegate <NSObject>

@optional
- (void)leftButtonClick;

- (void)rightButtonClick;

@end

@interface NavigatonBarView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIImageView *backGroundImgeView;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,assign) id<NavigatonBarViewDelegate>delegate;
@property (nonatomic,assign) NavigationBarStyle navagationBarStyle;


- (id)initLeftButtonPicNormal:(UIImage *)leftImageNormal
       leftButtonPicHighlight:(UIImage *)leftImageHighlight
         rightButtonPicNormal:(UIImage *)rightImageNormal
      rightButtonPicHighlight:(UIImage *)rightImageHighlight
                    fontColor:(UIColor *)color;

@end
