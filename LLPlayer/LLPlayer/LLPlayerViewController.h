//
//  LLPlayerViewController.h
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LLPlayerConfigure.h"
#import "LLPlaybackControlProtocol.h"

@interface LLPlayerViewController : UIViewController

@property (nonatomic, assign) ELayerVideoGravityType videoGravityType;

@property (nonatomic, assign) BOOL showsPlaybackControls;

@property (nonatomic, strong) NSURL *contentURL;

@property (nonatomic, copy) void(^fullScreenBlock)(id sender);
@property (nonatomic, copy) void(^shrinkScreenBlock)(id sender);
@property (nonatomic, copy) void(^backBlock)(id sender);

//MARK: 必须重写该方法
- (UIView<LLPlaybackControlViewProtocol> *)controlView;

- (void)play;
- (void)pause;

@end
