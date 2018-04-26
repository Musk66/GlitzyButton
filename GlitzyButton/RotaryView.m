//
//  RotaryView.m
//  GlitzyButton
//
//  Created by tiger on 16/10/20.
//  Copyright © 2016年 tiger. All rights reserved.
//

#import "RotaryView.h"
#import "GlitzyButton.h"

@interface RotaryView()

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@end

@implementation RotaryView

NSString *kAnimationStrokeKey = @"animationStrokeKey";
NSString *kAnimationRotationKey = @"animationRotationKey";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimating = NO;
        _hidesWhenStopped = NO;
        _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self.layer addSublayer:self.progressLayer];
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 2;
        //_progressLayer.shouldRasterize = YES;
    }
    return _progressLayer;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)resetAnimations {
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)startAnimating {
    if (self.isAnimating) {
        return ;
    }
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.0;
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.repeatCount = NSIntegerMax;
    [self.progressLayer addAnimation:animation forKey:kAnimationRotationKey];
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.0;
    headAnimation.fromValue = @(0);
    headAnimation.toValue = @(0.25);
    headAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.0;
    tailAnimation.fromValue = @(0);
    tailAnimation.toValue = @(1.0);
    tailAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.0;
    endHeadAnimation.duration = 0.5;
    endHeadAnimation.fromValue = @(0.25);
    endHeadAnimation.toValue = @(1.0);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.0;
    endTailAnimation.duration = 0.5;
    endTailAnimation.fromValue = @(1.0);
    endTailAnimation.toValue = @(1.0);
    endTailAnimation.timingFunction = self.timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.duration = 1.5;
    animations.animations = @[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation];
    animations.repeatCount = NSIntegerMax;
    [self.progressLayer addAnimation:animations forKey:kAnimationStrokeKey];
    
    self.isAnimating = YES;
    if (_hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating) {
        return ;
    }
    [self.progressLayer removeAnimationForKey:kAnimationRotationKey];
    [self.progressLayer removeAnimationForKey:kAnimationStrokeKey];
    self.isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (void)updatePath {
    CGPoint acenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    int aradius = MIN(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2-self.progressLayer.lineWidth/2);
    CGFloat astartAngle = 0;
    CGFloat aendAngle = 2*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:acenter radius:aradius startAngle:astartAngle endAngle:aendAngle clockwise:YES];
    
    self.progressLayer.path = path.CGPath;
    self.progressLayer.strokeStart = 0.0;
    self.progressLayer.strokeEnd = 0.0;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
