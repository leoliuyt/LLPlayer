//
//  LLPlayerViewController.m
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLPlayerViewController.h"
#import "LLPlayerView.h"

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface LLPlayerViewController ()<LLPlaybackControlProtocol>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) LLPlayerView *playerView;
@property (nonatomic, strong) UIView<LLPlaybackControlViewProtocol> *playbackControlView;

@property (nonatomic, copy) NSString *totalTime;

@property (nonatomic, strong) id<NSObject> playbackTimeObserver;


/**
 *  跳到time处播放
 *  @param seekTime这个时刻，这个时间点
 */
@property (nonatomic, assign) double  seekTime;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, copy) NSTimer *timer;

@property (nonatomic, assign, getter=isHidedToolBar) BOOL hidedToolBar;

@end

@implementation LLPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.seekTime = 0.0;
    [self.view addSubview:self.playerView];
    [self.playerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.playbackControlView = [self controlView];
    if (self.playbackControlView) {
        [self.view addSubview:self.playbackControlView];
        [self.playbackControlView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self addTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: 需要重写该方法
- (UIView<LLPlaybackControlViewProtocol> *)controlView {
//    LLPlaybackControlView *controlView = [[LLPlaybackControlView alloc] init];
//    controlView.delegate = self;
//    return controlView;
    return nil;
}

- (void)dealloc
{
    self.seekTime = 0;
    [self removeKVOObserver];
}

- (void)addTimer{
    //如果不显示控制界面 那么不需要添加计时器 自动隐藏功能失效
    if(!self.showsPlaybackControls){return;}
    if(self.timer) {
        [self removeTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:self.autoHideTime target:self selector:@selector(hideToolBar) userInfo:nil repeats:NO];
    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer{
    if(!self.showsPlaybackControls){return;}
    [self.timer invalidate];
    self.timer = nil;
}

- (void)hideToolBar
{
    self.hidedToolBar = YES;
    [self.playbackControlView hideToolBar:YES];
}

-(void)removeKVOObserver{
    if(self.playerItem)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
        [self.playerView.player replaceCurrentItemWithPlayerItem:nil];
    }
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)startLoading
{
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)stopLoading
{
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
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
    //要求在播放期间请求调用
    //CMTimeMake(1, 1) 每隔一秒调用一次block
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = CMTimeGetSeconds(playerItem.currentTime);// 计算当前在第几秒
        [weakSelf updateVideoSlider:currentSecond];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        if ([weakSelf.playbackControlView respondsToSelector:@selector(setPlayCurrentTime:totalTime:)]) {
            [weakSelf.playbackControlView setPlayCurrentTime:timeString totalTime:weakSelf.totalTime];
        }
    }];
}

- (void)configureVideoSlider:(CGFloat)maxValue
{
    if ([self.playbackControlView respondsToSelector:@selector(setProgressMaxValue:)]) {
        [self.playbackControlView setProgressMaxValue:maxValue];
    }
    //    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    //    UIGraphicsEndImageContext();
}
- (void)updateVideoSlider:(CGFloat)currentSecond {
    if ([self.playbackControlView respondsToSelector:@selector(updateProgress:)]) {
        [self.playbackControlView updateProgress:currentSecond];
    }
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self updateVideoSlider:0.0];
        [self.playbackControlView changePlayStatus:NO];
        [self.player pause];
    }];
}

///获取视频长度
- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([playerItem duration]);
    }
    else{
        return 0.f;
    }
}
/**
 *  跳到time处播放
 *  @param seekTime这个时刻，这个时间点
 */
- (void)seekToTimeToPlay:(double)time{
    if (self.player&&self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (time>[self duration]) {
            time = [self duration];
        }
        if (time<=0) {
            time=0.0;
        }
        //        int32_t timeScale = self.player.currentItem.asset.duration.timescale;
        //currentItem.asset.duration.timescale计算的时候严重堵塞主线程，慎用
        /* A timescale of 1 means you can only specify whole seconds to seek to. The timescale is the number of parts per second. Use 600 for video, as Apple recommends, since it is a product of the common video frame rates like 50, 60, 25 and 24 frames per second*/
        NSLog(@"######@@@@@##%tu",self.playerItem.currentTime.timescale);
        [self.player seekToTime:CMTimeMakeWithSeconds(time, self.playerItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        }];
    }
}
//MARK: Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.isHidedToolBar) {
        [self addTimer];
    } else {
        [self removeTimer];
    }
    [self.playbackControlView hideToolBar:!self.isHidedToolBar];
    self.hidedToolBar = !self.isHidedToolBar;
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
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, self.playerItem.currentTime.timescale);
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
    if(self.fullScreenBlock) {
        self.fullScreenBlock(sender);
    }
}

- (void)didClickShrinkScreenAction:(id)sender
{
    if (self.shrinkScreenBlock) {
        self.shrinkScreenBlock(sender);
    }
}

- (void)didClickBackAction:(id)sender
{
    if (self.backBlock) {
        self.backBlock(sender);
    }
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
                    CGFloat totalSecond = CMTimeGetSeconds(playerItem.duration);//获取视频总长度 并 转换成秒
                    NSLog(@"####%f",totalSecond);
                    self.totalTime = [self convertTime:totalSecond];// 转换成播放时间
                    [self configureVideoSlider:totalSecond];
                    [self monitoringPlayback:playerItem];// 监听播放状态
                    [self.playbackControlView changePlayStatus:YES];
                    if (self.seekTime) {
                        [self seekToTimeToPlay:self.seekTime];
                    }
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
                [self startLoading];
            }else{
                //remove loading
                [self stopLoading];
            }
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            [self startLoading];
            //            [self.loadingView startAnimating];
            //            // 当缓冲是空的时候
            //            if (self.currentItem.playbackBufferEmpty) {
            //                self.state = WMPlayerStateBuffering;
            //                [self loadedTimeRanges];
            //            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            [self stopLoading];
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
    AVPlayer *aPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = aPlayer;
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem==playerItem) {
        return;
    }
    if (_playerItem && playerItem) {
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
        
        [_playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:NSKeyValueObservingOptionNew
                         context:PlayViewStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_playerItem addObserver:self
                      forKeyPath:@"playbackBufferEmpty"
                         options: NSKeyValueObservingOptionNew
                         context:PlayViewStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_playerItem addObserver:self
                      forKeyPath:@"playbackLikelyToKeepUp"
                         options: NSKeyValueObservingOptionNew
                         context:PlayViewStatusObservationContext];
        
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }
}

- (void)setVideoGravityType:(ELayerVideoGravityType)videoGravityType
{
    _videoGravityType = videoGravityType;
    self.playerView.videoGravityType = videoGravityType;
}

- (void)setShowsPlaybackControls:(BOOL)showsPlaybackControls
{
    _showsPlaybackControls = showsPlaybackControls;
    self.playbackControlView.hidden = !showsPlaybackControls;
}

//MARK: Getter
- (CGFloat)autoHideTime
{
    if (_autoHideTime<0.00001) {
        return 3.;
    }
    return _autoHideTime;
}

//MARK:lazy
- (LLPlayerView *)playerView
{
    if(!_playerView){
        _playerView = [[LLPlayerView alloc] init];
    }
    return _playerView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
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
