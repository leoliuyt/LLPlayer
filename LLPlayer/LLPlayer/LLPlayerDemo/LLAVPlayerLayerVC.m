//
//  LLAVPlayerLayerVC.m
//  LLPlayer
//
//  Created by lbq on 2017/3/14.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLAVPlayerLayerVC.h"
#import <AVFoundation/AVFoundation.h>

@interface LLAVPlayerLayerVC ()

@end

@implementation LLAVPlayerLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self playAVPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playAVPlayer
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"moments" withExtension:@"mp4"];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playItem];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.view.frame;
    // 显示播放视频的视图层要添加到self.view的视图层上面
    [self.view.layer addSublayer:layer];
    
    [player play];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
