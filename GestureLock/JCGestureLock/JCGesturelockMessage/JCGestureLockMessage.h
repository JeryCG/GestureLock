//
//  JCGestureLockMessage.h
//  GestureLock
//
//  Created by jery on 2017/1/13.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCGestureLockMessage : NSObject

@property (nonatomic, assign) BOOL     isSucceed;
@property (nonatomic, assign) BOOL     isClose;

@property (nonatomic, strong) UIColor  * _Nonnull  animationColor;
@property (nonatomic, copy)   NSString * _Nonnull  animationMessage;
@property (nonatomic, copy)   NSString * _Nullable animationImage;
@property (nonatomic, copy)   NSString * _Nullable motionlessMessage;

+ (JCGestureLockMessage * _Nonnull)sharedMessage;

- (void)configurationMessage:(BOOL)isSucceed
                     isClose:(BOOL)isClose
              animationColor:(UIColor  * _Nonnull)animationColor
            animationMessage:(NSString * _Nonnull)animationMessage
              animationImage:(NSString * _Nullable)animationImage
           motionlessMessage:(NSString * _Nullable)motionlessMessage;
@end
