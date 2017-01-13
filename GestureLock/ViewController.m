//
//  ViewController.m
//  GestureLock
//
//  Created by jery on 2017/1/12.
//  Copyright © 2017年 J.C. All rights reserved.
//

#import "ViewController.h"
#import "JCGestrueLockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    JCGestureBackgroundView *v = [[JCGestureBackgroundView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
//    v.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
//    v.backgroundColor = self.view.backgroundColor;
//    [self.view addSubview:v];
}

- (IBAction)set:(id)sender {
    [JCGestrueLockViewController configWithLockType:setPassword succeed:^{
        NSLog(@"succeed");
    } failed:^{
        NSLog(@"failed");
    } others:nil];
}
- (IBAction)verify:(id)sender {
    [JCGestrueLockViewController configWithLockType:verifyPassword succeed:^{
        NSLog(@"succeed");
    } failed:^{
        NSLog(@"failed");
    } others:nil];
    
}
- (IBAction)modify:(id)sender {
    [JCGestrueLockViewController configWithLockType:modifyPassword succeed:^{
        NSLog(@"succeed");
    } failed:^{
        NSLog(@"failed");
    } others:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
