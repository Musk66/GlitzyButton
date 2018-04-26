//
//  RotaryView.h
//  GlitzyButton
//
//  Created by tiger on 16/10/20.
//  Copyright © 2016年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotaryView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
//@property (nonatomic, assign) CGSize contentIvSize;

FOUNDATION_EXTERN NSString *kAnimationStrokeKey;
FOUNDATION_EXTERN NSString *kAnimationRotationKey;


- (void)startAnimating;
- (void)stopAnimating;

@end
