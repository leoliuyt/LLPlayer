//
//  LLPlayerDemoVC.m
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlayerDemoVC.h"
#import "LLPlaybackControlView.h"

@interface LLPlayerDemoVC ()<LLPlaybackControlProtocol>

@end

@implementation LLPlayerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView<LLPlaybackControlViewProtocol> *)controlView
{
    LLPlaybackControlView *controlView = [[LLPlaybackControlView alloc] init];
    controlView.delegate = self;
    return controlView;
}
@end
