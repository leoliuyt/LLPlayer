//
//  LLPlayerView.h
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LLPlayerConfigure.h"

@interface LLPlayerView : UIView

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) ELayerVideoGravityType videoGravityType;

@end
