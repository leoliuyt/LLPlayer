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
//    NSURL *url = [NSURL URLWithString:@"http://cdn.ghs-tv.readtv.cn/video/12ac13b476496f5d308478f090ccf7c9/stream.m3u8"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"moments" withExtension:@"mp4"];
//    AVPlayer *player = [AVPlayer playerWithURL:url];
//    _llPlayerVC.player = player;
//    _llPlayerVC.contentURL = url;
    self.llPlayerVC.view.frame = CGRectMake(0, 64, 320, 400);
    self.llPlayerVC.videoGravityType = ELayerVideoGravityTypeResizeAspectFill;
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
//        AVPlayer *player = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"moments" withExtension:@"mp4"]];
//        NSURL *url = [NSURL URLWithString:@"http://cdn.ghs-tv.readtv.cn/video/12ac13b476496f5d308478f090ccf7c9/stream.m3u8"];
        NSURL *url = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=XMTcwNDE3NTgyOA==&type=mp4&ts=1472523895&keyframe=0&ep=dSaTGEyPVcYH7SbfjD8bZX2zJ34IXJZ3kkzC%252F6YXA8VAH6HA6DPcqJ6zTPs%253D&sid=7472523878504122aac97&token=3324&ctype=12&ev=1&oip=2937696939"];
//        AVPlayer *player = [AVPlayer playerWithURL:url];
//        _llPlayerVC.player = player;
        _llPlayerVC.contentURL = url;
    }
    return _llPlayerVC;
}
@end
