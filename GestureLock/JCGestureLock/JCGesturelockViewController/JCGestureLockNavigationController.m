//
//  JCGestureLockNavigationController.m
//  手势解锁
//
//  Created by jery on 2017/1/10.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "JCGestureLockNavigationController.h"
#import "JCGestureConst.h"

@interface JCGestureLockNavigationController ()

@end

@implementation JCGestureLockNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customBar];
}

- (void)customBar {
    self.navigationBar.tintColor = JCGetrueLockNavgationBarColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: JCGetrueLockNavgationBarColor}];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
