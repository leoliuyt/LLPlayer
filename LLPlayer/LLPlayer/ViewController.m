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
#import "LLNavigationController.h"
#import "LLFullScreenViewController.h"
#import "LLPlayerDemoVC.h"
#import "LLPlayerConfigure.h"

@interface ViewController ()

@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) LLPlayerViewController *llPlayerVC;

@property (nonatomic, strong) LLPlayerDemoVC *demoVC;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
//    [self playLLPlayerVCADD];
    [self playDemoVC];
}

- (IBAction)closePlayer:(id)sender {
    [self.llPlayerVC pause];
    [self.llPlayerVC.view removeFromSuperview];
    self.llPlayerVC = nil;
}
- (IBAction)jumpAction:(id)sender {
    [self.demoVC.view removeFromSuperview];
    LLFullScreenViewController *vc = [[LLFullScreenViewController alloc] init];
//    vc.videoPlayerVC = self.demoVC;
    LLNavigationController *nav = [[LLNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)playDemoVC
{
    self.demoVC.view.frame = CGRectMake(0, 64, 320, 200);
    self.demoVC.videoGravityType = ELayerVideoGravityTypeResizeAspectFill;
    [self.view addSubview:self.demoVC.view];
    [self.demoVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(200.);
    }];
    [self.demoVC play];
}

//MARK: LLPlayerViewController
- (void)playLLPlayerVC
{
    [self presentViewController:self.llPlayerVC animated:YES completion:^{
        [self.llPlayerVC play];
    }];
}

- (void)playLLPlayerVCADD
{
    self.llPlayerVC.view.frame = CGRectMake(0, 64, 320, 200);
    self.llPlayerVC.videoGravityType = ELayerVideoGravityTypeResizeAspectFill;
    [self.view addSubview:self.llPlayerVC.view];
    [self.llPlayerVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(200.);
    }];
    [self.llPlayerVC play];
}

//MARK: AVPlayerViewController
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
        _playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerVC.player = player;
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
        _llPlayerVC.contentURL = url;
    }
    return _llPlayerVC;
}

- (LLPlayerDemoVC *)demoVC
{
    if(!_demoVC){
        _demoVC = [[LLPlayerDemoVC alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=XMTcwNDE3NTgyOA==&type=mp4&ts=1472523895&keyframe=0&ep=dSaTGEyPVcYH7SbfjD8bZX2zJ34IXJZ3kkzC%252F6YXA8VAH6HA6DPcqJ6zTPs%253D&sid=7472523878504122aac97&token=3324&ctype=12&ev=1&oip=2937696939"];
        _demoVC.contentURL = url;
    }
    return _demoVC;
}

@end
