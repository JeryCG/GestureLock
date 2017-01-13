//
//  JCGestureBackgroundView.h
//  手势解锁
//
//  Created by jery on 2017/1/11.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, _JCGestureLockType){
    _setPassword = 0,
    _modifyPassword,
    _verifyPassword
};

typedef void(^lockSucceed)();
typedef void(^lockFailed)();
typedef void(^lockMessage)();

@interface JCGestureBackgroundView : UIView 

+ (instancetype)configIcons:(CGRect)frame
                   LockType:(_JCGestureLockType)lockType
                    succeed:(lockSucceed)succeed
                     failed:(lockFailed)failed
                    message:(lockMessage)message;

@end
