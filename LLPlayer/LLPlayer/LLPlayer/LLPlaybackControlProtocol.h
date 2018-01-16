//
//  LLPlaybackControlProtocol.h
//  LLPlayer
//
//  Created by lbq on 16/9/6.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EQuickType) {
    EQuickTypeForward,
    EQuickTypeBackward,
};
@protocol LLPlaybackControlProtocol <NSObject>

@optional
//播放 暂停
- (void)didClickPlayAction:(id)sender;

- (void)didClickPauseAction:(id)sender;

//全屏 小屏
- (void)didClickFullScreenAction:(id)sender;

- (void)didClickShrinkScreenAction:(id)sender;

//退出
- (void)didClickBackAction:(id)sender;

//播放进度相关
- (void)progressSliderValueChanged:(id)sender;

- (void)progressSliderValueChangedEnd:(id)sender;

//收拾 快进 快退
- (void)quickType:(EQuickType)quickType timeStr:(NSString *)timeStr;

@end

@protocol LLPlaybackControlViewProtocol <NSObject>

@required

@property (nonatomic, weak) id<LLPlaybackControlProtocol> delegate;

@optional
// 修改播放状态
- (void)changePlayStatus:(BOOL)isPlaying;

// 修改全屏状态
- (void)changeFullStatus:(BOOL)isFull;

//设置时间
-(void)setPlayCurrentTime:(NSString *)currentTime totalTime:(NSString *)aTotalTime;

// configure progress max value
- (void)setProgressMaxValue:(CGFloat)aMaxValue;

// 更新播放进度条
- (void)updateProgress:(CGFloat)currentSecond;

//隐藏toolbar
- (void)hideToolBar:(BOOL)isHide;

@end
