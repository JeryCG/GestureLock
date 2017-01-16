//
//  JCGestureBackgroundView.m
//  手势解锁
//
//  Created by jery on 2017/1/11.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureBackgroundView.h"
#import "JCGestureIcon.h"
#import "JCGestureConst.h"
#import "JCGestureLockCache.h"
#import "JCGestureLockMessage.h"

inline static void _configMsg(JCGestureLockMessage *message,
                              BOOL                 isSucceed,
                              BOOL                 isClose,
                              UIColor  * _Nonnull  animationColor,
                              NSString * _Nonnull  animationMessage,
                              NSString * _Nullable animationImage,
                              NSString * _Nullable motionlessMessage)
{
    [message configurationMessage:isSucceed
                          isClose:isClose
                   animationColor:animationColor
                 animationMessage:animationMessage
                   animationImage:animationImage
                motionlessMessage:motionlessMessage];
}

@interface JCGestureBackgroundView ()<CAAnimationDelegate> {
    BOOL       _isSure;
    CGPoint    _startPoint;
    CGPoint    _movePoint;
    NSUInteger _layerCount;
    NSUInteger _inLineCount;
}

@property (nonatomic, assign) _JCGestureLockType lockType;
@property (nonatomic, copy)   NSString           *lockPassword;
@property (nonatomic, copy)   NSString           *sureLockPassword;
@property (nonatomic, copy)   lockSucceed        succeed;
@property (nonatomic, copy)   lockFailed         failed;
@property (nonatomic, copy)   lockMessage        message;

@end

@implementation JCGestureBackgroundView

+ (instancetype)configIcons:(CGRect)frame
                   LockType:(_JCGestureLockType)lockType
                    succeed:(lockSucceed)succeed
                     failed:(lockFailed)failed
                    message:(lockMessage)message {
    
    return [[self alloc]initWithFrame:frame
                             LockType:lockType
                              succeed:succeed
                               failed:failed
                              message:message];
}

- (instancetype)initWithFrame:(CGRect)frame
                     LockType:(_JCGestureLockType)lockType
                      succeed:(lockSucceed)succeed
                       failed:(lockFailed)failed
                       message:(lockMessage)message {
    
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    _succeed  = succeed;
    _failed   = failed;
    _message  = message;
    _lockType = lockType;
    
    [self configIcons];
    
    return self;
}

- (void)configIcons {
    for (NSInteger i = 0; i < 9 ; i++) {
        CGFloat x = i % 3;
        CGFloat y = i / 3;
        
        CGRect rect = CGRectMake(x * Icon_Width + Icon_Width / 2 * .4f,
                                 y * Icon_Width,
                                 Icon_Width * .6f,
                                 Icon_Width * .6f);
        CGSize size = CGSizeMake(rect.size.width / 3, rect.size.width / 3);
        JCGestureIcon *icon = [[JCGestureIcon alloc]initWithFrame:rect
                                                      BorderColor:JCIconDefaultColor
                                                       CenterSize:size
                                                      CenterColor:JCIconDefaultColor];
        icon.selectColor = JCIconSelectedColor;
        icon.animationType = animationTypeButton;
        icon.tag = 300 + i;
        [self addSubview:icon];
    }
    
    _layerCount = self.layer.sublayers.count;
    _inLineCount = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * t = [touches anyObject];
    CGPoint loc = [t locationInView:self];
    
    for (JCGestureIcon *icon in self.subviews) {
        if (CGRectContainsPoint(icon.frame, loc)) {
            if (icon.userInteractionEnabled){
                [icon beSelected];
                
                _startPoint = icon.center;
                _inLineCount = 1;
                
                if (!_isSure)  _lockPassword = [NSString stringWithFormat:@"%li", icon.tag];
                else       _sureLockPassword = [NSString stringWithFormat:@"%li", icon.tag];
                
                break;
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_startPoint.x == 0) {
        [super touchesEnded:touches withEvent:event]; return;
    }
    
    if (self.layer.sublayers.count > _layerCount) {
        [self.layer.sublayers[_layerCount] removeFromSuperlayer];
    }
    
    CAShapeLayer *sl = [CAShapeLayer new];
    sl.frame         = self.layer.bounds;
    sl.lineWidth     = lineWidth;
    sl.fillColor     = [UIColor clearColor].CGColor;
    sl.strokeColor   = JCIconSelectedColor.CGColor;
    sl.lineJoin      = kCALineJoinRound;
    sl.lineCap       = kCALineCapRound;
    [self.layer addSublayer:sl];
    
    UIBezierPath *path = [UIBezierPath new];
    
    UITouch *t = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [t locationInView:self])) {
        _movePoint = [t locationInView:self];
    }
    
    for (JCGestureIcon *icon in self.subviews) {
        if (CGRectContainsPoint(icon.frame, _movePoint)) {
            if (icon.userInteractionEnabled){
                [path moveToPoint:_startPoint];
                [path addLineToPoint:icon.center];
                
                sl.path = path.CGPath;
                [path closePath];
                
                [icon beSelected];
                
                if (!_isSure) {
                    _lockPassword = [_lockPassword stringByAppendingFormat:@"%li", icon.tag];
                } else {
                    _sureLockPassword = [_sureLockPassword stringByAppendingFormat:@"%li", icon.tag];
                }
                _startPoint = icon.center;
                
                _layerCount++; _inLineCount++;
                
                return;
            }
        }
    }
    
    [path moveToPoint:_startPoint];
    [path addLineToPoint:_movePoint];
    
    sl.path = path.CGPath;
    [path closePath];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self lockEvents];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self lockEvents];
}

- (void)lockEvents {
    JCGestureLockMessage *message = [JCGestureLockMessage sharedMessage];
    
    if (_inLineCount == 0) return;
    
    else if (_inLineCount < 4 && _inLineCount > 0) {
        [self reload];
        
        _configMsg(message, NO, NO, JCMsgErrorColor, msgIconCountError, imageError, nil);
        _message(message);
        
        return;
    }
    
    switch (_lockType) {
        case _setPassword: {
            if (_isSure) {
                if ([_lockPassword isEqualToString:_sureLockPassword]) {
                    if ([JCGestureLockCache isCacheLockPassword])
                        [JCGestureLockCache removePassword];
                    
                    [JCGestureLockCache setLockPassword:_sureLockPassword];
                    [self reload]; _isSure = NO;

                    _configMsg(message, YES, YES, JCMsgDefaultColor, msgSetSucceed, imageCorrect, msgSetPassword);
                    _message(message);
                    
                    _succeed();
                } else {
                    [self reload]; _isSure = YES;
             
                    _configMsg(message, NO, NO, JCMsgErrorColor, msgSetFailed, imageError, msgSetSure);
                    _message(message);
                    
                    _failed();
                }
            }  else {
                [self reload]; _isSure = YES;
       
                _configMsg(message, YES, NO, JCMsgDefaultColor, msgSetSure, imageDefault, msgSetSure);
                _message(message);
            }
        }
            break;
            
        case _modifyPassword:{
            if ([[JCGestureLockCache getLockPassword] isEqualToString:_lockPassword]) {
                _lockType = _setPassword;
                
                [self reload];

                _configMsg(message, YES, NO, JCMsgDefaultColor, msgModifySureOld, imageDefault, msgSetPassword);
                _message(message);
            } else {
                [self reload];

                _configMsg(message, NO, NO, JCMsgErrorColor, msgModifyFailed, imageError, msgModifyPassword);
                _message(message);
                
                _failed();
            }
        }
            break;
            
        case _verifyPassword: {
            if ([[JCGestureLockCache getLockPassword] isEqualToString:_lockPassword]) {
                [self reload];

                _configMsg(message, YES, YES, JCMsgDefaultColor, msgVerifySucceed, imageCorrect, msgVerifyPassword);
                _message(message);
                
                _succeed();
            } else {
                [self reload];

                _configMsg(message, NO, NO, JCMsgErrorColor, msgVerifyFailed, imageError, msgVerifyPassword);
                _message(message);
                
                _failed();
            }
        }
            break;
    }
}

- (void)reload {
    self.userInteractionEnabled = YES;
    
    _startPoint = _movePoint = CGPointZero;
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self configIcons];
}

- (void)animationDidStart:(CAKeyframeAnimation *)anim {
    self.userInteractionEnabled = NO;
}

- (void)animationDidStop:(CAKeyframeAnimation *)anim finished:(BOOL)flag {
    [self reload];
}

@end
