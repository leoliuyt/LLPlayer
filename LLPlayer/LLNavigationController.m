//
//  LLNavigationController.m
//  LLPlayer
//
//  Created by leoliu on 16/10/15.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLNavigationController.h"

@interface LLNavigationController ()

@end

@implementation LLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 因为 presented 完成后，控制器的view的frame会错乱，需要每次将要展现的时候强制设置一下
    self.view.frame = [UIScreen mainScreen].bounds;
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    //    return UIStatusBarStyleLightContent;
    //    return self.whiteBgColor ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}
@end
