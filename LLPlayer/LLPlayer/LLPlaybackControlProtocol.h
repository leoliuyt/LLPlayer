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

//播放进度相关
- (void)progressSliderValueChanged:(id)sender;

- (void)progressSliderValueChangedEnd:(id)sender;

//收拾 快进 快退
- (void)quickType:(EQuickType)quickType timeStr:(NSString *)timeStr;

@end
