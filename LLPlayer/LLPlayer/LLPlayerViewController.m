//
//  LLPlayerViewController.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlayerViewController.h"
#import "LLPlayerView.h"
#import "LLPlaybackControlView.h"
#import "LLPlaybackControlProtocol.h"

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface LLPlayerViewController ()<LLPlaybackControlProtocol>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) LLPlayerView *playerView;
@property (nonatomic, strong) LLPlaybackControlView *playbackControlView;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, copy) NSString *totalTime;

@property (nonatomic, strong) id playbackTimeObserver;

@end

@implementation LLPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    [self.playerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.playbackControlView];
    [self.playbackControlView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeKVOObserver];
}

-(void)removeKVOObserver{
    if(self.playerItem)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.playerView.player replaceCurrentItemWithPlayerItem:nil];
    }
    self.playerItem = nil;
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    __weak LLPlayerViewController *weakSelf = self;
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        [weakSelf updateVideoSlider:currentSecond];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",timeString,weakSelf.totalTime]];
        [attri addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange([timeString length], [_totalTime length] + 1)];
        
        weakSelf.playbackControlView.timeLabel.attributedText = attri;
    }];
}

- (void)configureVideoSlider:(CMTime)duration
{
    self.playbackControlView.progressSlider.maximumValue = CMTimeGetSeconds(duration);
//    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
//    UIGraphicsEndImageContext();
}
- (void)updateVideoSlider:(CGFloat)currentSecond {
    [self.playbackControlView.progressSlider setValue:currentSecond animated:YES];
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self updateVideoSlider:0.0];
        [self.playbackControlView changePlayStatus:NO];
        [self.player pause];
    }];
}

//MARK: LLPlaybackControlProtocol
//播放进度相关
- (void)progressSliderValueChanged:(id)sender {
    UISlider *slider = sender;
    [self.playbackControlView changePlayStatus:NO];
    [self.player pause];
    if (slider.value == 0.000000) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [self.playbackControlView changePlayStatus:YES];
                [self.player play];
            }];
        }
    }
}

- (void)progressSliderValueChangedEnd:(id)sender {
    UISlider *slider = sender;
    [self.playbackControlView changePlayStatus:NO];
    [self.player pause];
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
            [self.playbackControlView changePlayStatus:YES];
            [self.player play];
        }];
    }
}

//播放 暂停
- (void)didClickPlayAction:(id)sender
{
    [self.player play];
}

- (void)didClickPauseAction:(id)sender
{
    [self.player pause];
}

//全屏 小屏
- (void)didClickFullScreenAction:(id)sender
{
    
}

- (void)didClickShrinkScreenAction:(id)sender
{
    
}

//收拾 快进 快退
- (void)quickType:(EQuickType)quickType timeStr:(NSString *)timeStr
{
    
}

//MARK: Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == PlayViewStatusObservationContext)
    {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status) {
                case AVPlayerStatusUnknown:
                {
                    
                }
                break;
                case AVPlayerStatusReadyToPlay:
                {
                    NSLog(@"####%lld",playerItem.duration.value/playerItem.duration.timescale);
                    CMTime duration = playerItem.duration;// 获取视频总长度
                    CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
                    self.totalTime = [self convertTime:totalSecond];// 转换成播放时间
                    [self configureVideoSlider:duration];
                    [self monitoringPlayback:playerItem];// 监听播放状态
                    [self.playbackControlView changePlayStatus:YES];
                }
                break;
                case AVPlayerStatusFailed:
                {
                    
                }
                break;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSLog(@"---####%lld",playerItem.currentTime.value/playerItem.currentTime.timescale);
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
            if (timeInterval < currentSecond) {
                //loading
            }else{
                //remove loading
            }
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
//            [self.loadingView startAnimating];
//            // 当缓冲是空的时候
//            if (self.currentItem.playbackBufferEmpty) {
//                self.state = WMPlayerStateBuffering;
//                [self loadedTimeRanges];
//            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
//            [self.loadingView stopAnimating];
//            // 当缓冲好的时候
//            if (self.currentItem.playbackLikelyToKeepUp && self.state == WMPlayerStateBuffering){
//                self.state = WMPlayerStatePlaying;
//            }
        }
    }
}

//MARK: Setter
- (void)setPlayer:(AVPlayer *)player
{
    _player = player;
    self.playerView.player = player;
}

- (void)setContentURL:(NSURL *)contentURL
{
    _contentURL = contentURL;
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
    self.playerItem = playerItem;
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    AVPlayer *aPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = aPlayer;
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem==playerItem) {
        return;
    }
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        _playerItem = nil;
    }
    _playerItem = playerItem;
    if (_playerItem) {
        [_playerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:PlayViewStatusObservationContext];
        
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }
}

- (void)setVideoGravityType:(ELayerVideoGravityType)videoGravityType
{
    _videoGravityType = videoGravityType;
    switch (videoGravityType) {
        case ELayerVideoGravityTypeResize:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        case ELayerVideoGravityTypeResizeAspect:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ELayerVideoGravityTypeResizeAspectFill:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
    }
}   

- (void)setShowsPlaybackControls:(BOOL)showsPlaybackControls
{
    _showsPlaybackControls = showsPlaybackControls;
    self.playbackControlView.hidden = !showsPlaybackControls;
}

//MARK:lazy
- (LLPlayerView *)playerView
{
    if(!_playerView){
        _playerView = [[LLPlayerView alloc] init];
    }
    return _playerView;
}

- (LLPlaybackControlView *)playbackControlView
{
    if(!_playbackControlView){
        _playbackControlView = [[LLPlaybackControlView alloc] init];
        _playbackControlView.delegate = self;
    }
    return _playbackControlView;
}


//- (void)addLaytout
//{
//    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *playerViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewRigthConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.];
//    NSLayoutConstraint *playerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.];
//    [self.view addConstraints:@[
//                                playerViewLeftConstraint,
//                                playerViewRigthConstraint,
//                                playerViewTopConstraint,
//                                playerViewBottomConstraint
//                                ]];
//}

@end
