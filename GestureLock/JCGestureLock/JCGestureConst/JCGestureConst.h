//
//  JCGestureConst.h
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JCUserDefaults [NSUserDefaults standardUserDefaults]
#define Screen_Width   [UIScreen mainScreen].bounds.size.width
#define Screen_Height  [UIScreen mainScreen].bounds.size.height
#define Icon_Width     [UIScreen mainScreen].bounds.size.width / 3

#define JCColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define JCGetrueLockNavgationBarColor JCColor(0.f, 102.f, 255.f, .9f)
#define JCIconDefaultColor            JCColor(107.f, 198.f, 221.f, 1.f)
#define JCIconSelectedColor           JCColor(19.f, 157.f, 191.f, 1.f)
#define JCMsgDefaultColor             JCColor(68.f, 197.f, 250.f, 1.f)
#define JCMsgErrorColor               JCColor(250.f, 89.f, 68.f, 1.f)
#define JCButtonColor                 JCColor(0.f, 102.f, 255.f, .9f)

UIKIT_EXTERN const CGFloat closeDuration;
UIKIT_EXTERN const CGFloat lineWidth;

UIKIT_EXTERN NSString *const JCGesturelockKey;

UIKIT_EXTERN NSString *const setPasswordTitle;
UIKIT_EXTERN NSString *const modifyPasswordTitle;
UIKIT_EXTERN NSString *const verifyPasswordTitle;

UIKIT_EXTERN NSString *const msgSetPassword;
UIKIT_EXTERN NSString *const msgSetSure;
UIKIT_EXTERN NSString *const msgSetSucceed;
UIKIT_EXTERN NSString *const msgSetFailed;

UIKIT_EXTERN NSString *const msgModifyPassword;
UIKIT_EXTERN NSString *const msgModifySureOld;
UIKIT_EXTERN NSString *const msgModifySucceed;
UIKIT_EXTERN NSString *const msgModifyFailed;

UIKIT_EXTERN NSString *const msgVerifyPassword;
UIKIT_EXTERN NSString *const msgVerifySucceed;
UIKIT_EXTERN NSString *const msgVerifyFailed;

UIKIT_EXTERN NSString *const msgIconCountError;

UIKIT_EXTERN NSString *const imageDefault;
UIKIT_EXTERN NSString *const imageError;
UIKIT_EXTERN NSString *const imageCorrect;
