//
//  JCGestureLockCache.m
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureLockCache.h"
#import "JCGestureConst.h"

@implementation JCGestureLockCache

+ (BOOL)isCacheLockPassword {
    if ([[JCUserDefaults stringForKey:JCGesturelockKey] isEqualToString:@""] ||
        ![JCUserDefaults stringForKey:JCGesturelockKey]) {
        return NO;
    }
    return YES;
}

+ (NSString *)getLockPassword {
    return [JCUserDefaults stringForKey:JCGesturelockKey];
}

+ (void)setLockPassword:(NSString *)lockPassword {
    [JCUserDefaults setObject:lockPassword forKey:JCGesturelockKey];
}

+ (void)removePassword {
    [JCUserDefaults removeObjectForKey:JCGesturelockKey];
}

@end

@implementation NSObject (JCGestureExtension)

- (id)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
