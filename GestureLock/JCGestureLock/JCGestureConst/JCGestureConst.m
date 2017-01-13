//
//  JCGestureConst.m
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//
#import <UIKit/UIKit.h>

const CGFloat closeDuration = 1.f;

NSString *const JCGesturelockKey    = @"JCGesturelockKey";

NSString *const setPasswordTitle    = @"设置手势密码";
NSString *const modifyPasswordTitle = @"修改手势密码";
NSString *const verifyPasswordTitle = @"验证手势密码";

NSString *const msgSetPassword      = @"请滑动设置手势密码";
NSString *const msgSetSure          = @"请再次滑动确定密码";
NSString *const msgSetSucceed       = @"手势密码设置成功!";
NSString *const msgSetFailed        = @"两次手势密码不一致!";

NSString *const msgModifyPassword   = @"请输入旧密码";
NSString *const msgModifySureOld    = @"旧密码正确";
NSString *const msgModifySucceed    = @"新密码设置成功!";
NSString *const msgModifyFailed     = @"旧密码错误!";

NSString *const msgVerifyPassword   = @"请滑动验证密码";
NSString *const msgVerifySucceed    = @"手势密码正确!";
NSString *const msgVerifyFailed     = @"手势密码错误!";

NSString *const msgIconCountError   = @"至少连接4个点,请重新输入!";

NSString *const imageDefault        = @"LockDefault";
NSString *const imageError          = @"LockError";
NSString *const imageCorrect        = @"LockCorrect";
