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
#import "LLAVPlayerLayerVC.h"

@interface ViewController ()

@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) LLPlayerDemoVC *demoVC;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playAction:(id)sender {
    [self playDemoVC];
}

- (IBAction)closePlayer:(id)sender {
    [self.demoVC pause];
    [self.demoVC.view removeFromSuperview];
    self.demoVC = nil;
}

- (IBAction)clickAVPlayerVC:(id)sender {
    [self playAVPlayerVC];
}

- (IBAction)clickAVPlayerLayer:(id)sender {
    [self playAVPlayer];
}

//MARK: 继承LLAVPlayerViewController实现的
- (void)playDemoVC
{
    self.demoVC.view.frame = CGRectMake(0, 0, 320, 200);
    self.demoVC.videoGravityType = ELayerVideoGravityTypeResizeAspectFill;
    WEAKSELF(weakSelf);
    self.demoVC.backBlock = ^(id sender){
        [weakSelf.demoVC pause];
        [weakSelf.demoVC.view removeFromSuperview];
        weakSelf.demoVC = nil;
    };
    [self.view addSubview:self.demoVC.view];
    [self.demoVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64.);
        make.height.equalTo(200.);
    }];
    [self.demoVC play];
}

//MARK: AVPlayerLayer(系统原生)
- (void)playAVPlayer
{
    LLAVPlayerLayerVC *vc = [[LLAVPlayerLayerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: AVPlayerViewController(系统原生)
- (void)playAVPlayerVC
{
    [self presentViewController:self.playerVC animated:YES completion:^{
        [self.playerVC.player play];
        
        NSLog(@"%tu",self.playerVC.readyForDisplay);
    }];
}

//MARK: lazy
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
