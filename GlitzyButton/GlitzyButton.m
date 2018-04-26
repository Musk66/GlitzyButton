//
//  GlitzyButton.m
//  GlitzyButton
//
//  Created by tiger on 16/10/20.
//  Copyright © 2016年 tiger. All rights reserved.
//

//  Glitzy 闪光的，耀眼的

#import "GlitzyButton.h"
#import "RotaryView.h"

@interface GlitzyButton()

@property (nonatomic, assign) CGFloat defaultW;
@property (nonatomic, assign) CGFloat defaultH;
@property (nonatomic, assign) CGFloat defaultR;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImage *btnBackgroundImage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIColor *progressColor;
//圆圈view
@property (nonatomic, strong) RotaryView *rotaryView;
//RotaryView中间图标
@property (nonatomic, copy) UIImageView *contentIv;

@end

@implementation GlitzyButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSettingWithColor:self.tintColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.isLoading = NO;
        [self initSettingWithColor:color];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    //self.forDisplayButton.selected = selected;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    //self.forDisplayButton.highlighted = highlighted;
}

- (void)initSettingWithColor:(UIColor *)color {
    self.scale = 1.2;
    _bgView = [[UIView alloc] initWithFrame:self.bounds];
    _bgView.backgroundColor = color;
    _bgView.userInteractionEnabled = NO;
    _bgView.hidden = YES;
    _bgView.layer.cornerRadius = 3;
    [self addSubview:self.bgView];
    
    _defaultW = _bgView.frame.size.width;
    _defaultH = _bgView.frame.size.height;
    _defaultR = _bgView.layer.cornerRadius;
    
    _rotaryView = [[RotaryView alloc] initWithFrame:CGRectMake(0 , 0, _defaultH*0.8, _defaultH*0.8)];
    _rotaryView.tintColor = [UIColor whiteColor];
    _rotaryView.lineWidth = 2;
    _rotaryView.center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    _rotaryView.translatesAutoresizingMaskIntoConstraints = NO;
    _rotaryView.userInteractionEnabled = NO;
    [self addTarget:self action:@selector(loadingAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rotaryView];
    
    _forDisplayButton = [[UIButton alloc] initWithFrame:self.bounds];
    _forDisplayButton.userInteractionEnabled = NO;
    
    UIImage *image = [self imageWithColor:color andCornerRadius:3];
    [_forDisplayButton setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self addSubview:self.forDisplayButton];
}

- (void)loadingAction {
    NSLog(@"事件！");
    if (self.isLoading) {
        [self stopLoading];
    }else{
        [self startLoading];
    }
}

- (void)startLoading {
    if (!_btnBackgroundImage) {
        _btnBackgroundImage = [self.forDisplayButton backgroundImageForState:UIControlStateNormal];
    }
    [self.forDisplayButton setTitle:@"" forState:UIControlStateNormal];
    [self.rotaryView addSubview:self.contentIv];
    self.rotaryView.hidden = NO;
    
    self.isLoading = YES;
    self.bgView.hidden = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(_defaultR);
    animation.toValue = @(_defaultH*_scale*0.5);
    animation.duration = 0.3;
    _bgView.layer.cornerRadius = _defaultH*_scale*0.5;
    [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
    [self.forDisplayButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _defaultW*_scale, _defaultH*_scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _defaultH*_scale, _defaultH*_scale);
            _forDisplayButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
            _forDisplayButton.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                _forDisplayButton.hidden = YES;
                [self.rotaryView startAnimating];
            }
        }];
    }];
}

- (void)stopLoading {
    [self.rotaryView stopAnimating];
    self.rotaryView.hidden = YES;
    self.contentIv = nil;
    [self.contentIv removeFromSuperview];
    [self.forDisplayButton setTitle:self.btnTitle forState:UIControlStateNormal];
    _forDisplayButton.hidden = NO;
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _forDisplayButton.transform = CGAffineTransformMakeScale(1, 1);
        _forDisplayButton.alpha = 1;
    } completion:^(BOOL finished) {
        //
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(_defaultH*_scale*0.5);
    animation.toValue = @(_defaultR);
    animation.duration = 0.3;
    _bgView.layer.cornerRadius = _defaultR;
    [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _defaultW*_scale, _defaultH*_scale);
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @(_bgView.layer.cornerRadius);
        animation.toValue = @(_defaultR);
        animation.duration = 0.2;
        self.bgView.layer.cornerRadius = _defaultR;
        [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
        
        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _defaultW, _defaultH);
        } completion:^(BOOL finished) {
            if (self.btnBackgroundImage) {
                [_forDisplayButton setBackgroundImage:self.btnBackgroundImage forState:UIControlStateNormal];
            }
            _bgView.hidden = YES;
            self.isLoading = NO;
        }];
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color andCornerRadius:(CGFloat)cornerRadius {
    CGRect rect = CGRectMake(0, 0, cornerRadius*2+10, cornerRadius*2+10);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    path.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    [path fill];
    [path stroke];
    [path addClip];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)contentIv {
    if (!_contentIv) {
        CGSize contentIvSize = CGSizeMake(self.forDisplayButton.imageView.frame.size.width, self.forDisplayButton.imageView.frame.size.height);
        _contentIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentIvSize.width-1, contentIvSize.height-1)];
        _contentIv.center = CGPointMake(CGRectGetMidX(self.rotaryView.layer.bounds), CGRectGetMidY(self.rotaryView.layer.bounds));
        [_contentIv setImage:[self.forDisplayButton imageForState:UIControlStateNormal]];
    }
    return _contentIv;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
