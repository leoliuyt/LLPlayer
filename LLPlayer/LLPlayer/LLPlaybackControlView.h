//
//  LLPlaybackControlView.h
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPlaybackControlBaseView.h"

@interface LLPlaybackControlView :UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *fullBtn;
@property (nonatomic, strong) UIButton *shrinkBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) id<LLPlaybackControlProtocol> delegate;

- (void)changePlayStatus:(BOOL)play;

@end
