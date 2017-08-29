//
//  JCGestureMaskView.m
//  GestureLock
//
//  Created by jery on 2017/1/13.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureMaskView.h"

@implementation JCGestureMaskView

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    UIColor *startColor = _centerColor;
    UIColor *endColor   = _edgeColor;
    UIColor *colors[2]  = {startColor, endColor};
    CGFloat components[2 * 4];
    
    for (int i = 0; i < 2; i++) {
        CGColorRef tmpcolorRef = colors[i].CGColor;
        const CGFloat *tmpcomponents = CGColorGetComponents(tmpcolorRef);
        for (int j = 0; j < 4; j++) {
            components[i * 4 + j] = tmpcomponents[j];
        }
    }
    components[3] = .3f;
    
    gradient = CGGradientCreateWithColorComponents(rgb, components, NULL, sizeof(components)/(sizeof(components[0])*4));
    CGColorSpaceRelease(rgb);
    
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = MAX(width, height) / 2;
    
    CGPoint start = CGPointMake(radius, radius);
    CGPoint end   = CGPointMake(radius, radius);
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = radius;
    
    CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, 0);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
