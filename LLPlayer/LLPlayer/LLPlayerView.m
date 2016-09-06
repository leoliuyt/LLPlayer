//
//  LLPlayerView.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlayerView.h"

@implementation LLPlayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer
{
    return (AVPlayerLayer*)[self layer];
}

- (AVPlayer*)player{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

//- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer
//{
//    _playerLayer = playerLayer;
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.playerLayer.frame = self.frame;
//    if (![self.layer.sublayers containsObject:self.playerLayer]) {
//        [self.layer addSublayer:self.playerLayer];
//    }
//}

@end
