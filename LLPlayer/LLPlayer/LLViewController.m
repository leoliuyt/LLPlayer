//
//  LLViewController.m
//  LLPlayer
//
//  Created by leoliu on 16/10/15.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLViewController.h"

@interface LLViewController ()

@end

@implementation LLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)topViewController
{
    UIViewController *topviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topviewController.presentedViewController)
    {
        topviewController = topviewController.presentedViewController;
    }
    return topviewController;
}

#pragma mark - StatusBar

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //    return self.whiteBgColor ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return self.hidenStatusBar;
}


#pragma mark - rotate

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
