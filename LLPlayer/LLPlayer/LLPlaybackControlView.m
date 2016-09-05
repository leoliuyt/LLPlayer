//
//  LLPlaybackControlView.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlaybackControlView.h"
#define LLPlayerSrcName(file) [@"LLPlayer.bundle" stringByAppendingPathComponent:file]

static CGFloat kToolHeight = 40; //标题和底部视图的高度

@interface LLPlaybackControlView()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *fullBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LLPlaybackControlView

- (instancetype)init
{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    [self makeUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self makeUI];
    return self;
}

- (void)makeUI
{
    [self addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(kToolHeight);
    }];
    
    [self addSubview:self.bottomView];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(kToolHeight);
    }];
    
    [self.topView addSubview:self.backBtn];
    [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.topView);
        make.width.equalTo(kToolHeight);
    }];
    
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.right).offset(10.);
        make.top.bottom.right.equalTo(self.topView);
    }];
    
    [self.bottomView addSubview:self.playBtn];
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(kToolHeight);
    }];
    
    [self.bottomView addSubview:self.fullBtn];
    [self.fullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(kToolHeight);
    }];
    
}

//MARK:lazy
- (UIView *)topView
{
    if(!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _bottomView;
}

- (UIButton *)backBtn
{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-close")] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)playBtn
{
    if(!_playBtn){
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-play")] forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UIButton *)fullBtn
{
    if(!_fullBtn){
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-fullscreen")] forState:UIControlStateNormal];
    }
    return _fullBtn;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
@end
