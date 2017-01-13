//
//  JCGestrueLockViewController.h
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lockSucceed)();
typedef void(^lockFailed)();
typedef void(^lockOthers)();

typedef NS_ENUM(NSInteger, JCGestureLockType){
    setPassword = 0,
    modifyPassword,
    verifyPassword
};

@interface JCGestrueLockViewController: UIViewController

+ (instancetype)configWithLockType:(JCGestureLockType)lockType
                           succeed:(lockSucceed)succeed
                            failed:(lockFailed)failed
                            others:(lockOthers)others;

@end
