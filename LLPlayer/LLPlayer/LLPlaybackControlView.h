//
//  LLPlaybackControlView.h
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPlaybackControlProtocol.h"

@interface LLPlaybackControlView :UIView<LLPlaybackControlViewProtocol>
//MARK: LLPlaybackControlViewProtocol 方法
@property (nonatomic, weak) id<LLPlaybackControlProtocol> delegate;

- (void)changePlayStatus:(BOOL)play;

- (void)setProgressMaxValue:(CGFloat)aMaxValue;

- (void)setPlayCurrentTime:(NSString *)currentTime totalTime:(NSString *)aTotalTime;

- (void)updateProgress:(CGFloat)currentSecond;

- (void)hideToolBar:(BOOL)isHide;

@end
