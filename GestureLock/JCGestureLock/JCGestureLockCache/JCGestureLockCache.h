//
//  JCGestureLockCache.h
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCGestureLockCache : NSObject

+ (BOOL)isCacheLockPassword;

+ (NSString *)getLockPassword;

+ (void)setLockPassword:(NSString *)lockPassword;

+ (void)removePassword;

@end

@interface NSObject (JCGestureExtension)

- (id)getCurrentVC;

@end
