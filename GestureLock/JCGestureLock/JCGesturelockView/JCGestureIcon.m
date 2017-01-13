//
//  JCGestureIcon.m
//  手势解锁
//
//  Created by jery on 2017/1/9.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureIcon.h"

@interface JCGestureIcon ()

@property (nonatomic, strong) CAShapeLayer *centerLayer;

@end

@implementation JCGestureIcon

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame
                  BorderColor:(UIColor *)borderColor
                   CenterSize:(CGSize)centerSize
                  CenterColor:(UIColor *)centerColor {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self configFrame:frame
          BorderColor:borderColor
           CenterSize:centerSize
          CenterColor:centerColor];
    
    return self;
}

- (void)configFrame:(CGRect)frame
        BorderColor:(UIColor *)borderColor
         CenterSize:(CGSize)centerSize
        CenterColor:(UIColor *)centerColor {
    
    CAShapeLayer *sl = (CAShapeLayer *)self.layer;
    sl.cornerRadius  = frame.size.width / 2;
    sl.borderColor   = borderColor.CGColor;
    sl.borderWidth   = 2.f;
    
    _centerLayer = [CAShapeLayer new];
    _centerLayer.frame = CGRectMake(0, 0, centerSize.width, centerSize.height);
    _centerLayer.cornerRadius = centerSize.width / 2;
    _centerLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    _centerLayer.backgroundColor = centerColor.CGColor;
    [sl addSublayer:_centerLayer];
    
    _animationType = animationTypeDefault;
}

- (void)beSelected {
    self.userInteractionEnabled = NO;
    CAShapeLayer *sl = (CAShapeLayer *)self.layer;
    
    if (_selectColor) sl.borderColor = _centerLayer.backgroundColor = _selectColor.CGColor;
    else        sl.borderColor = _centerLayer.backgroundColor = [UIColor redColor].CGColor;
    
    switch (_animationType) {
        case animationTypeDefault: [self animationDefault]; break;
        case animationTypeShake:   [self animationShake];   break;
        case animationTypeScale:   [self animationScale];   break;
        case animationTypeNone: break;
    }
}

- (void)animationDefault {
    CGFloat scale = self.bounds.size.width / _centerLayer.bounds.size.width;
    
    CABasicAnimation *defaultAnimation = [CABasicAnimation animation];
    defaultAnimation.keyPath = @"transform.scale";
    defaultAnimation.duration = .3f;
    defaultAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    defaultAnimation.toValue = [NSNumber numberWithFloat:MIN(1.5f, scale)];
    defaultAnimation.autoreverses = YES;
    defaultAnimation.removedOnCompletion = YES;
    
    [_centerLayer addAnimation:defaultAnimation forKey:@"default"];
}

- (void)animationShake {
    CGFloat offset = 6.f;
    NSArray *values = @[
                        @(-offset),
                        @(0),
                        @(offset)
                        ];
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    shakeAnimation.keyPath = @"transform.translation.x";
    shakeAnimation.duration = .2f;
    shakeAnimation.repeatCount = 2.f;
    shakeAnimation.values = values;
    shakeAnimation.removedOnCompletion = YES;
    
    CAShapeLayer *sl = (CAShapeLayer *)self.layer;
    [sl addAnimation:shakeAnimation forKey:@"shake"];
}

- (void)animationScale {
    CGFloat radius   = self.bounds.size.width / 2;
    CGFloat width    = self.bounds.size.width;
    CGFloat height   = self.bounds.size.height;
    CGFloat center_x = width / 2;
    CGFloat center_y = height / 2;
    
    NSArray *scaleValues = @[
                             [NSValue valueWithCGSize:CGSizeMake(width * .7f, width * .7f)],
                             [NSValue valueWithCGSize:CGSizeMake(width * 1.2f, width * 1.2f)],
                             [NSValue valueWithCGSize:CGSizeMake(width, width)]
                             ];
    NSArray *radiusValues = @[
                              @(radius * .7f),
                              @(radius * 1.2f),
                              @(radius)
                              ];
    NSArray *positionValues = @[
                                [NSValue valueWithCGPoint:CGPointMake(center_x * .7f,
                                                                      center_y * .7f)],
                                [NSValue valueWithCGPoint:CGPointMake(center_x * 1.2f,
                                                                      center_y * 1.2f)],
                                [NSValue valueWithCGPoint:CGPointMake(center_x, center_y)]
                                ];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"bounds.size";
    scaleAnimation.values = scaleValues;

    CAKeyframeAnimation *radiusAnimation = [CAKeyframeAnimation animation];
    radiusAnimation.keyPath = @"cornerRadius";
    radiusAnimation.values = radiusValues;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnimation, radiusAnimation];
    group.duration = .4f;
    group.repeatCount = 1.f;
    group.removedOnCompletion = YES;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.duration = .4f;
    positionAnimation.keyPath = @"position";
    positionAnimation.values = positionValues;
    positionAnimation.removedOnCompletion = YES;
    
    CAShapeLayer *sl = (CAShapeLayer *)self.layer;
    
    [sl addAnimation:group forKey:@"ggroup"];
    [_centerLayer addAnimation:positionAnimation forKey:@"position"];
}

@end
