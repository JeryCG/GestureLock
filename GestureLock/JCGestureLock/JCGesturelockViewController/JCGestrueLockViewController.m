//
//  JCGestrueLockViewController.m
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestrueLockViewController.h"
#import "JCGestureConst.h"
#import "JCGestureIcon.h"
#import "JCGestureLockCache.h"
#import "JCGestureLockNavigationController.h"
#import "JCGestureBackgroundView.h"
#import "JCGestureLockMessage.h"

static BOOL _isModifyPassword = NO;

@interface JCGestrueLockViewController ()<CAAnimationDelegate> {
    BOOL        _isClose;
    NSString    *_motionlessMessage;
    UILabel     *_msgLabel;
    UIImageView *_lockImageView;
}

@property (nonatomic, assign) JCGestureLockType lockType;
@property (nonatomic, copy)   NSString          *lockPassword;
@property (nonatomic, copy)   NSString          *sureLockPassword;
@property (nonatomic, copy)   lockSucceed       succeed;
@property (nonatomic, copy)   lockFailed        failed;
@property (nonatomic, copy)   lockOthers        others;

@end

@implementation JCGestrueLockViewController

+ (instancetype)configWithLockType:(JCGestureLockType)lockType
                           succeed:(lockSucceed)succeed
                            failed:(lockFailed)failed
                            others:(lockOthers)others {
    
    return [[self alloc]_initWithLockType:lockType
                                  succeed:succeed
                                   failed:failed
                                   others:others];
}

- (instancetype)_initWithLockType:(JCGestureLockType)lockType
                         succeed:(lockSucceed)succeed
                           failed:(lockFailed)failed
                           others:(lockOthers)others {
    self = [super init];
    if (self == nil) return nil;
    
    _lockType = lockType;
    _succeed  = succeed;
    _failed   = failed;
    _others   = others;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_lockType == setPassword) {
        if ([JCGestureLockCache isCacheLockPassword]) {
            _failed(); return nil;
        }
    } else {
        if (![JCGestureLockCache isCacheLockPassword]) {
            _failed(); return nil;
        }
    }
    
    if (_isModifyPassword) {
        _isModifyPassword = !_isModifyPassword;
        return self;
    }
    
    id vc = [self getCurrentVC];
    JCGestureLockNavigationController *nav = [[JCGestureLockNavigationController alloc]initWithRootViewController:self];
    [vc presentViewController:nav animated:YES completion:nil];

    return self;
}

- (void)setBottomButtons {
    NSArray *buttonTitleArray = @[
                                  @"忘记密码",
                                  @"修改密码"
                                  ];
    
    for (NSInteger i = 0 ; i < 2; i++) {
        UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(i * Screen_Width / 2,
                                                                Screen_Height - 40, Screen_Width / 2, 30)];
        b.titleLabel.font = [UIFont systemFontOfSize:14.f];
        b.titleLabel.textAlignment = NSTextAlignmentCenter;
        [b setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [b setTitleColor:JCButtonColor forState:UIControlStateNormal];
        [b addTarget:self action:@selector(bottomButtonClick:) forControlEvents:1 << 6];
        
        b.tag = 200 + i;
        [self.view addSubview:b];
    }
}

- (void)bottomButtonClick:(UIButton *)b {
    switch (b.tag) {
        case 200: {
            [self closeLock];
            !_others? :_others();
        }
            break;
        case 201:{
            _isModifyPassword = YES;
            JCGestrueLockViewController *vc = [self.class configWithLockType:modifyPassword
                                                                     succeed:_succeed
                                                                      failed:_failed
                                                                      others:_others];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

- (void)setCloseButton {
    UIBarButtonItem *l = [[UIBarButtonItem alloc]initWithTitle:@"关闭"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(closeLock)];
    self.navigationItem.leftBarButtonItem = l;
}

- (void)closeLock {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)closeLockWait:(NSTimeInterval)duration {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeLock];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configInterface];
}

- (void)configInterface {
    switch (_lockType) {
        case setPassword:
            [self _configSetPasswordInterface];
            break;
            
        case modifyPassword:
            [self _configModifyPasswordInterface];
            break;
            
        case verifyPassword:
            [self _configVerifyPasswordInterface];
            break;
    }
    
    _msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width / 3 * 2, 20)];
    _msgLabel.center = CGPointMake(Screen_Width / 2, 20 + 64);
    _msgLabel.font = [UIFont systemFontOfSize:16.f];
    _msgLabel.textColor = JCMsgDefaultColor;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.backgroundColor = self.view.backgroundColor;
    _msgLabel.text = _motionlessMessage;
    [self.view addSubview:_msgLabel];
    
    _lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _lockImageView.center = CGPointMake(Screen_Width / 2, 150);
    _lockImageView.image = [UIImage imageNamed:imageDefault];
    [self.view addSubview:_lockImageView];
    
    [self.view addSubview:[self configIcons]];
}

- (void)_configSetPasswordInterface {
    [self setCloseButton];
    
    self.navigationItem.title = setPasswordTitle;
    _motionlessMessage = msgSetPassword;
}

- (void)_configModifyPasswordInterface {
    [self setCloseButton];
    
    self.navigationItem.title = modifyPasswordTitle;
    _motionlessMessage = msgModifyPassword;
}

- (void)_configVerifyPasswordInterface {
    [self setBottomButtons];
    
    self.navigationItem.title = verifyPasswordTitle;
    _motionlessMessage = msgVerifyPassword;
}

- (JCGestureBackgroundView *)configIcons {
    NSInteger type = _lockType;
    CGRect    rect = CGRectMake(0, Screen_Height - Screen_Width - 10,
                                Screen_Width, Screen_Width - Icon_Width * .4f);
    
    __weak typeof(self) weakSelf = self;
    
    return [JCGestureBackgroundView configIcons:rect
                                       LockType:type
                                        succeed:_succeed
                                         failed:_failed
                                        message:^(JCGestureLockMessage *message)
    {
        [weakSelf handleMessage:message];
    }];
}

- (void)handleMessage:(JCGestureLockMessage *)message {
    BOOL     isSucceed         = message.isSucceed;
    BOOL     isColse           = message.isClose;
    UIColor  *animationColor   = message.animationColor;
    NSString *animationMessage = message.animationMessage;
    NSString *animationImage   = message.animationImage;
    
    if (isSucceed == NO) {
        [self msgShake:NO];
    } else {
       [self msgShake:YES];
        _motionlessMessage = message.motionlessMessage;
    }
    
    _isClose             = isColse;
    _msgLabel.textColor  = animationColor;
    _msgLabel.text       = animationMessage;
    _lockImageView.image = [UIImage imageNamed:animationImage];
}

- (void)msgShake:(BOOL)isSucceed {
    CGFloat s;
    NSString *keyPath;
    
    if (isSucceed) {
        s = 4.f; keyPath = @"transform.translation.y";
    } else {
        s = 8.f; keyPath = @"transform.translation.x"; 
    }
    
    CAKeyframeAnimation *promptAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    promptAnimation.delegate = self;
    promptAnimation.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    promptAnimation.duration = .2f;
    promptAnimation.repeatCount = 2.f;
    promptAnimation.removedOnCompletion = YES;
    [_msgLabel.layer addAnimation:promptAnimation forKey:@"prompt"];
}

- (void)animationDidStop:(CAKeyframeAnimation *)anim finished:(BOOL)flag {
    _msgLabel.text       = _motionlessMessage;
    _msgLabel.textColor  = JCMsgDefaultColor;
    _lockImageView.image = [UIImage imageNamed:imageDefault];
    
    !_isClose? :[self closeLockWait:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
