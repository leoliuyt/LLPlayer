//
//  LLPlaybackControlView.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlaybackControlView.h"
#import "LLPlayerConfigure.h"

static CGFloat kToolHeight = 40; //标题和底部视图的高度

@interface LLPlaybackControlView()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

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
    
    [self.bottomView addSubview:self.pauseBtn];
    [self.pauseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(kToolHeight);
    }];
    
    [self.bottomView addSubview:self.fullBtn];
    [self.fullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(kToolHeight);
    }];
    
    [self.bottomView addSubview:self.shrinkBtn];
    [self.shrinkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(kToolHeight);
    }];
    
    [self.bottomView addSubview:self.progressSlider];
    [self.progressSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).offset(10.);
        make.right.equalTo(self.fullBtn.left).offset(-10);
        make.centerY.equalTo(self.bottomView);
        make.height.equalTo(20.);
    }];
    
    [self.bottomView addSubview:self.timeLabel];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.bottom);
        make.bottom.equalTo(self.bottomView);
    }];
}

- (void)changePlayStatus:(BOOL)play
{
    if (play) {
        self.playBtn.hidden = YES;
        self.pauseBtn.hidden = NO;
    } else {
        self.playBtn.hidden = NO;
        self.pauseBtn.hidden = YES;
    }
}

- (void)changeFullStatus:(BOOL)full
{
    if (full) {
        self.fullBtn.hidden = YES;
        self.shrinkBtn.hidden = NO;
    } else {
        self.fullBtn.hidden = NO;
        self.shrinkBtn.hidden = YES;
    }
}

//MARK: buton Action
- (void)playAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickPlayAction:)]) {
        [self.delegate didClickPlayAction:sender];
        [self changePlayStatus:YES];
    }
}

- (void)pauseAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickPauseAction:)]) {
        [self.delegate didClickPauseAction:sender];
        [self changePlayStatus:NO];
    }
}

- (void)fullAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickFullScreenAction:)]) {
        [self.delegate didClickFullScreenAction:sender];
        [self changeFullStatus:YES];
    }
}

- (void)shrinkAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickShrinkScreenAction:)]) {
        [self.delegate didClickShrinkScreenAction:sender];
        [self changeFullStatus:NO];
    }
}

- (void)backAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickBackAction:)]) {
        [self.delegate didClickBackAction:sender];
    }
}

- (void)progressSliderValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(progressSliderValueChanged:)]) {
        [self.delegate progressSliderValueChanged:sender];
    }
}

- (void)progressSliderValueChangedEnd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(progressSliderValueChangedEnd:)]) {
        [self.delegate progressSliderValueChangedEnd:sender];
    }
}

//收拾 快进 快退
- (void)quickType:(EQuickType)quickType timeStr:(NSString *)timeStr
{
    
}

//MARK: LLPlaybackControlViewProtocol
- (void)setProgressMaxValue:(CGFloat)aMaxValue
{
    self.progressSlider.maximumValue = aMaxValue;
}

-(void)setPlayCurrentTime:(NSString *)currentTime totalTime:(NSString *)aTotalTime
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",currentTime,aTotalTime]];
    [attri addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange([currentTime length], [aTotalTime length] + 1)];
    self.timeLabel.attributedText = attri;
}

- (void)updateProgress:(CGFloat)currentSecond
{
    [self.progressSlider setValue:currentSecond animated:YES];
}

- (void)hideToolBar:(BOOL)isHide{
    self.topView.hidden = isHide;
    self.bottomView.hidden = isHide;
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
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)playBtn
{
    if(!_playBtn){
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-play")] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)pauseBtn
{
    if(!_pauseBtn){
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-pause")] forState:UIControlStateNormal];
        [_pauseBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
        _pauseBtn.hidden = YES;
    }
    return _pauseBtn;
}

- (UIButton *)fullBtn
{
    if(!_fullBtn){
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-fullscreen")] forState:UIControlStateNormal];
         [_fullBtn addTarget:self action:@selector(fullAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}

- (UIButton *)shrinkBtn
{
    if(!_shrinkBtn){
        _shrinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkBtn setImage:[UIImage imageNamed:LLPlayerSrcName(@"kr-video-player-shrinkscreen")] forState:UIControlStateNormal];
        [_shrinkBtn addTarget:self action:@selector(shrinkAction:) forControlEvents:UIControlEventTouchUpInside];
        _shrinkBtn.hidden = YES;
    }
    return _shrinkBtn;
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

- (UISlider *)progressSlider
{
    if(!_progressSlider){
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setMinimumTrackImage:[UIImage imageNamed:LLPlayerSrcName(@"icon_player_progress")] forState:UIControlStateNormal];
        [_progressSlider setMaximumTrackImage:[UIImage imageNamed:LLPlayerSrcName(@"icon_player_backprogress")] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[UIImage imageNamed:LLPlayerSrcName(@"icon_audio_thumail")] forState:UIControlStateNormal];
        [_progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(progressSliderValueChangedEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressSlider;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.];
    }
    return _timeLabel;
}
@end
