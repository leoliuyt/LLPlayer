//
//  LLFullViewController.m
//  LLPlayer
//
//  Created by leoliu on 2018/1/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "LLFullViewController.h"

@interface LLFullViewController ()

@end

@implementation LLFullViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self                            selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification
     object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)deviceOrientationDidChange
{
    if(self.vc.state != ELLPlayViewStateFull){
        return;
    }
    switch (UIDevice.currentDevice.orientation) {
            case UIDeviceOrientationPortrait:
        {
            self.vc.state = ELLPlayViewStateAnimating;
            [self dismissViewControllerAnimated:YES completion:^{
                self.vc.state = ELLPlayViewStateSmall;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vc.view.frame = self.view.bounds;
    [self.vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
     }];
}

@end
