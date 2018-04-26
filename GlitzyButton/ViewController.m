//
//  ViewController.m
//  GlitzyButton
//
//  Created by tiger on 16/10/20.
//  Copyright © 2016年 tiger. All rights reserved.
//

#import "ViewController.h"
#import "GlitzyButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addSubView1];
    [self addSubView2];
}

- (void)addSubView1
{
    GlitzyButton *glitzyButton = [[GlitzyButton alloc] initWithFrame:CGRectMake(100, 100, 140, 36) andColor:[self getColor:@"e13536"]];
    [self.view addSubview:glitzyButton];
    [glitzyButton.forDisplayButton setTitle:@"微博登录" forState:UIControlStateNormal];
    glitzyButton.forDisplayButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [glitzyButton.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    glitzyButton.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [glitzyButton.forDisplayButton setImage:[UIImage imageNamed:@"微博logo.png"] forState:UIControlStateNormal];
    [glitzyButton addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [glitzyButton setBtnTitle:@"哈哈1"];
    glitzyButton.btnTitle = [glitzyButton.forDisplayButton titleForState:UIControlStateNormal];
}

- (void)addSubView2
{
    GlitzyButton *glitzyButton2 = [[GlitzyButton alloc] initWithFrame:CGRectMake(100, 200, 140, 36) andColor:[UIColor colorWithRed:0.110 green:0.776 blue:0.043 alpha:1.000]];
    [self.view addSubview:glitzyButton2];
    [glitzyButton2.forDisplayButton setTitle:@"微信登录" forState:UIControlStateNormal];
    glitzyButton2.forDisplayButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [glitzyButton2.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    glitzyButton2.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [glitzyButton2.forDisplayButton setImage:[UIImage imageNamed:@"微信logo.png"] forState:UIControlStateNormal];
    [glitzyButton2 addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    glitzyButton2.btnTitle = [glitzyButton2.forDisplayButton titleForState:UIControlStateNormal];
}

- (void)btnEvent:(GlitzyButton *)sender {
    NSLog(@"%s, %s", __func__, __FUNCTION__);
    NSLog(@"%@", sender.btnTitle);
    //NSLog(@"%@", [sender.forDisplayButton titleForState:UIControlStateNormal]);
}

- (UIColor *)getColor:(NSString *)hexColor {
    uint redInt = 0;
    uint greenInt = 0;
    uint blueInt = 0;
    NSRange range = NSMakeRange(0, 2);
    NSScanner *scanner = [NSScanner scannerWithString:[hexColor substringWithRange:range]];
    [scanner scanHexInt:&redInt];
    [scanner scanHexInt:&greenInt];
    [scanner scanHexInt:&blueInt];
    return [UIColor colorWithRed:redInt/255.0f green:greenInt/255.0f blue:blueInt/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
