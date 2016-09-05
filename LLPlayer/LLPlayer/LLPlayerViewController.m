//
//  LLPlayerViewController.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlayerViewController.h"
#import "LLPlayerView.h"
#import "LLPlaybackControlView.h"

@interface LLPlayerViewController ()

@property (nonatomic, strong) LLPlayerView *playerView;
@property (nonatomic, strong) LLPlaybackControlView *playbackControlView;

@end

@implementation LLPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    [self.playerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.playbackControlView];
    [self.playbackControlView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    [self addLaytout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Setter
- (void)setPlayer:(AVPlayer *)player
{
    _player = player;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerView.playerLayer = playerLayer;
}

- (void)setVideoGravityType:(ELayerVideoGravityType)videoGravityType
{
    _videoGravityType = videoGravityType;
    switch (videoGravityType) {
        case ELayerVideoGravityTypeResize:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        case ELayerVideoGravityTypeResizeAspect:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ELayerVideoGravityTypeResizeAspectFill:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
    }
}

- (void)setShowsPlaybackControls:(BOOL)showsPlaybackControls
{
    _showsPlaybackControls = showsPlaybackControls;
    self.playbackControlView.hidden = !showsPlaybackControls;
}

//MARK:lazy
- (LLPlayerView *)playerView
{
    if(!_playerView){
        _playerView = [[LLPlayerView alloc] init];
    }
    return _playerView;
}

- (LLPlaybackControlView *)playbackControlView
{
    if(!_playbackControlView){
        _playbackControlView = [[LLPlaybackControlView alloc] init];
    }
    return _playbackControlView;
}

//- (void)addLaytout
//{
//    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *playerViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewRigthConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.];
//    [self.view addConstraints:@[
//                                playerViewLeftConstraint,
//                                playerViewRigthConstraint,
//                                playerViewTopConstraint,
//                                playerViewBottomConstraint
//                                ]];
//}

@end
