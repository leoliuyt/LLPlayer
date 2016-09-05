//
//  ViewController.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LLPlayerViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) LLPlayerViewController *llPlayerVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAction:(id)sender {
//    [self playAVPlayerVC];
//    [self playAVPlayerVCPush];
//    [self playAVPlayer];
//    [self playAVPlayerVCADD];
//    [self playLLPlayerVC];
    [self playLLPlayerVCADD];
}

- (void)playLLPlayerVC
{
    [self presentViewController:self.llPlayerVC animated:YES completion:^{
        [self.llPlayerVC.player play];
    }];
}

- (void)playLLPlayerVCADD
{
    self.llPlayerVC.view.frame = CGRectMake(0, 64, 320, 400);
    self.llPlayerVC.videoGravityType = ELayerVideoGravityTypeResize;
    [self.view addSubview:self.llPlayerVC.view];
    [self.llPlayerVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(400.);
    }];
    [self.llPlayerVC.player play];
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

- (void)playAVPlayerVC
{
    [self presentViewController:self.playerVC animated:YES completion:^{
        [self.playerVC.player play];
        
        NSLog(@"%tu",self.playerVC.readyForDisplay);
    }];
}

- (void)playAVPlayerVCADD
{
    self.playerVC.view.frame = CGRectMake(0, 64, 320, 400);
    [self.view addSubview:self.playerVC.view];
    [self.playerVC.player play];
}

- (void)playAVPlayerVCPush
{
    [self.navigationController pushViewController:self.playerVC animated:YES];
    [self.playerVC.player play];
}

- (AVPlayerViewController *)playerVC
{
    if(!_playerVC){
        _playerVC = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"moments" withExtension:@"mp4"]];
        _playerVC.showsPlaybackControls = YES;
//        NSString * const AVLayerVideoGravityResize;
//        NSString * const AVLayerVideoGravityResizeAspect; //default
//        NSString * const AVLayerVideoGravityResizeAspectFill;
        _playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerVC.player = player;
//        _playerVC.player.
    }
    return _playerVC;
}

- (LLPlayerViewController *)llPlayerVC
{
    if(!_llPlayerVC){
        _llPlayerVC = [[LLPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"moments" withExtension:@"mp4"]];
        _llPlayerVC.player = player;
    }
    return _llPlayerVC;
}
@end
