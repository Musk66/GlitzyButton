//
//  GlitzyButton.h
//  GlitzyButton
//
//  Created by tiger on 16/10/20.
//  Copyright © 2016年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GlitzyButton : UIControl

//控件中的按钮
@property (nonatomic, strong) UIButton *forDisplayButton;
//按钮的标题
@property (nonatomic, strong) NSString *btnTitle;

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color;

@end
