//
//  LLFullScreenViewController.m
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLFullScreenViewController.h"
#import "LLPlayerViewController.h"
#import "UIView+LL.h"

static CGFloat kAnimationDuration = 0.28;

@interface LLFullScreenViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIViewController *appTopViewController;

@property (nonatomic, assign) CGRect finalFrame;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) UIModalPresentationStyle previousModalPresentationStyle;


@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, strong) UIControl *disappearControl;


@end

@implementation LLFullScreenViewController

#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil animatedFromView:(UIView *)view
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configure];
        self.originalView = view;
    }
    return self;
}

- (void)configure
{
    self.isPortrait = YES;
    [self.navigationController setNavigationBarHidden:YES];
    self.animationDuration = kAnimationDuration;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    else
    {
        self.appTopViewController = [self topViewController];
        self.previousModalPresentationStyle = self.appTopViewController.modalPresentationStyle;
        self.appTopViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
}

#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(shrinkScreenAction:)];
//    
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarShowOrHide:) name:kNotificationToolBarShowOrHide object:nil];
//    self.navigationController.navigationBarHidden = YES;
//    
//    self.bgImageView = [[UIImageView alloc]initWithImage:self.bgImage];
//    [self.view addSubview:self.bgImageView];
//    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    [self.view addSubview:self.disappearControl];
//    [self.disappearControl makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [self.disappearControl addTarget:self action:@selector(disappearVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self performAnimationShow];
    
    [self addChildViewController:self.videoPlayerVC];
    [self.videoPlayerVC didMoveToParentViewController:self];
//    self.videoPlayerVC.view.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.view addSubview:self.videoPlayerVC.view];
    [self.videoPlayerVC.view makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(frame.size.height);
//        make.width.equalTo(frame.size.width);
//        make.center.equalTo(weakSelf.view);
        make.edges.equalTo(self.view);
    }];
    
    WEAKSELF(weakSelf);
    self.videoPlayerVC.fullScreenBlock = ^(id sender){
        [weakSelf fullScreenAction:sender];
    };
    
    self.videoPlayerVC.shrinkScreenBlock = ^(id sender){
        [weakSelf shrinkScreenAction:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - notification

- (void)toolbarShowOrHide:(NSNotification *)noti{
    if (!self.isPortrait) {
        BOOL isHide = [noti.object boolValue];
        self.hidenStatusBar = isHide;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Action

- (void)shrinkScreenAction:(id)sender
{
    self.isPortrait = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.videoPlayerVC.isPortrait = YES;

//    [self.videoPlayerVC.view remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self.finalFrame.size.height);
//        make.width.equalTo(self.finalFrame.size.width);
//        make.center.equalTo(self.view);
//    }];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    self.disappearControl.enabled = YES;
}

- (void)fullScreenAction:(id)sender
{
    self.hidenStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.isPortrait = NO;
    self.disappearControl.enabled = NO;
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.videoPlayerVC.isPortrait = NO;
    [self.videoPlayerVC.view remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)disappearVC:(id)sender
{
    [self performAnimationClose];
}

#pragma mark - animation

- (void)performAnimationShow
{
    self.disappearControl.alpha = 0.;
    self.originalView.backgroundColor = [UIColor blackColor];
    UIImage *snipOriginImage = [self.originalView ll_snip];
    self.originalFrame = [self.originalView.superview convertRect:self.originalView.frame toView:nil];
    UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:snipOriginImage];
    resizableImageView.frame = self.originalFrame;
    resizableImageView.clipsToBounds = YES;
    resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizableImageView.backgroundColor = [UIColor clearColor];
    [LEOAppDelegate.window addSubview:resizableImageView];
    WEAKSELF(weakSelf)
    void(^completion)(CGRect frame) = ^(CGRect frame) {
        [weakSelf addChildViewController:weakSelf.videoPlayerVC];
        [weakSelf.videoPlayerVC didMoveToParentViewController:weakSelf];
        weakSelf.videoPlayerVC.view.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [weakSelf.view addSubview:weakSelf.videoPlayerVC.view];
        [weakSelf.videoPlayerVC.view makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(frame.size.height);
            make.width.equalTo(frame.size.width);
            make.center.equalTo(weakSelf.view);
        }];
        weakSelf.videoPlayerVC.view.backgroundColor = weakSelf.originalView.backgroundColor;
//        weakSelf.videoPlayerVC.isPortrait = YES;
//        [weakSelf.videoPlayerVC playUrl:@"http://video1.ileci.com/word/deceive_s.mp4"];
//        weakSelf.videoPlayerVC.fullScreenBlock = ^(id sender){
//            [weakSelf fullScreenAction:sender];
//        };
//        weakSelf.videoPlayerVC.shrinkScreenBlock = ^(id sender){
//            [weakSelf shrinkScreenAction:sender];
//        };
        [resizableImageView removeFromSuperview];
    };
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.disappearControl.alpha = 0.8;
    } completion:nil];
    
    float scaleFactor = (snipOriginImage ? snipOriginImage.size.width : kScreenW) / kScreenW;
    CGRect finalImageViewFrame = CGRectMake(0, (kScreenH/2)-((snipOriginImage.size.height / scaleFactor)/2), kScreenW, snipOriginImage.size.height / scaleFactor);
    self.finalFrame = finalImageViewFrame;
    [UIView animateWithDuration:self.animationDuration animations:^{
        resizableImageView.layer.frame = finalImageViewFrame;
    } completion:^(BOOL finished) {
        completion(finalImageViewFrame);
    }];
}

- (void)performAnimationClose
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UIImage *snipImage = [self.videoPlayerVC.view ll_snip];
    float scaleFactor = snipImage.size.width / kScreenW;
    UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:snipImage];
    resizableImageView.frame = (snipImage) ? CGRectMake(0, (kScreenH/2)-((snipImage.size.height / scaleFactor)/2), kScreenW, snipImage.size.height / scaleFactor) : CGRectZero;
    resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizableImageView.backgroundColor = [UIColor clearColor];
    resizableImageView.clipsToBounds = YES;
    [LEOAppDelegate.window addSubview:resizableImageView];
    self.videoPlayerVC.view.hidden = YES;
    WEAKSELF(weakSelf)
    void (^completion)() = ^() {
        weakSelf.originalView.hidden = NO;
        [resizableImageView removeFromSuperview];
        [weakSelf dismissPhotoBrowserAnimated:NO];
    };
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.disappearControl.alpha = 0.;
    } completion:nil];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        resizableImageView.layer.frame = self.originalFrame;
    } completion:^(BOOL finished) {
        completion();
    }];
}

#pragma mark - dismiss

- (void)dismissPhotoBrowserAnimated:(BOOL)animated
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    WEAKSELF(weakSelf)
    [self dismissViewControllerAnimated:animated completion:^{
        if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        {
            weakSelf.appTopViewController.modalPresentationStyle = self.previousModalPresentationStyle;
        }
    }];
}

#pragma mark - override - rotate

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.isPortrait ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.isPortrait ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeRight;
}

#pragma mark - lazy

- (UIImageView *)bgImageView
{
    if(!_bgImage)
    {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (LLPlayerViewController *)videoPlayerVC
{
    if(!_videoPlayerVC)
    {
//        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        _videoPlayerVC = (LEOVideoPlayerViewController *)[mainSB instantiateViewControllerWithIdentifier:@"VideoPlayerVC"];
        _videoPlayerVC = [[LLPlayerViewController alloc] init];
    }
    return _videoPlayerVC;
}

- (UIControl *)disappearControl
{
    if(!_disappearControl)
    {
        _disappearControl = [[UIControl alloc]init];
        _disappearControl.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    }
    return _disappearControl;
}

@end
