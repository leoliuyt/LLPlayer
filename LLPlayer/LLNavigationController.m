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
