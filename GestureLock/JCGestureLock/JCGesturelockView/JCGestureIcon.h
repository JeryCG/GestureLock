//
//  JCGestureIcon.h
//  手势解锁
//
//  Created by jery on 2017/1/9.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JCGestureIconAnimationType){
    animationTypeDefault,
    animationTypeTouch,
    animationTypeShake,
    animationTypeScale,
    animationTypeMask,
    animationTypeNone
};

@interface JCGestureIcon : UIView

@property (nonatomic, assign) JCGestureIconAnimationType animationType;
@property (nonatomic, strong) UIColor *selectColor;

- (instancetype)initWithFrame:(CGRect)frame
                  BorderColor:(UIColor *)borderColor
                   CenterSize:(CGSize)centerSize
                  CenterColor:(UIColor *)centerColor;

- (void)beSelected;

@end
