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

// 视频显示模式 类似图片的ContentMode
@property (nonatomic, assign) ELayerVideoGravityType videoGravityType;

//是否显示控制界面 如果为NO 自动隐藏将失效
@property (nonatomic, assign) BOOL showsPlaybackControls;

//控制界面的自动隐藏时间 默认3s
@property (nonatomic, assign) CGFloat autoHideTime;
//视频链接 可以是本地路径URL
@property (nonatomic, strong) NSURL *contentURL;

//横屏
@property (nonatomic, copy) void(^fullScreenBlock)(id sender);

//竖屏
@property (nonatomic, copy) void(^shrinkScreenBlock)(id sender);

//返回
@property (nonatomic, copy) void(^backBlock)(id sender);

//MARK: 必须重写该方法
- (UIView<LLPlaybackControlViewProtocol> *)controlView;

- (void)play;
- (void)pause;

@end
