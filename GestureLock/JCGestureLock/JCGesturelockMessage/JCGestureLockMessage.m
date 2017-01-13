//
//  JCGestureLockMessage.m
//  GestureLock
//
//  Created by jery on 2017/1/13.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureLockMessage.h"

@implementation JCGestureLockMessage

+ (JCGestureLockMessage * _Nonnull)sharedMessage {
    static JCGestureLockMessage *message;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        message = [[self alloc]init];
    });
    return message;
}

- (void)configurationMessage:(BOOL)isSucceed
                     isClose:(BOOL)isClose
              animationColor:(UIColor  * _Nonnull)animationColor
            animationMessage:(NSString * _Nonnull)animationMessage
              animationImage:(NSString * _Nullable)animationImage
           motionlessMessage:(NSString * _Nullable)motionlessMessage {
    
    _isSucceed          = isSucceed;
    _isClose            = isClose;
    _animationColor     = animationColor;
    _animationMessage   = animationMessage;
    _animationImage     = animationImage;
    _motionlessMessage  = motionlessMessage;
}

@end
