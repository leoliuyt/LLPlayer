//
//  LLList2ViewController.m
//  LLPlayer
//
//  Created by leoliu on 2018/1/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "LLList2ViewController.h"
#import "LLFullScreenViewController.h"
#import "LLPlayerCell.h"
#import "UIView+LL.h"
#import "LLNavigationController.h"
#import "LLPlayerViewController.h"
#import "LLEnterFullScreenTransition.h"
#import "LLExitFullScreenTransition.h"
#import "LLLandscapeLeftViewController.h"
#import "LLLandscapeRightViewController.h"

@interface LLList2ViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) LLPlayerViewController *playerVC;
@property (nonatomic, strong) LLFullViewController *controller;
@end

@implementation LLList2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)enterFullscreen
{
    if(self.playerVC.state != ELLPlayViewStateSmall){
        return;
    }
    LLLandscapeRightViewController *vc = [[LLLandscapeRightViewController alloc] init];
    [self present:vc];
}

- (void)exitFullScreen
{
    if(self.playerVC.state != ELLPlayViewStateFull){
        return;
    }
    self.playerVC.state = ELLPlayViewStateAnimating;
    [self.controller dismissViewControllerAnimated:YES completion:^{
        self.playerVC.state = ELLPlayViewStateSmall;
    }];
}

- (void)present:(LLFullViewController *)vc
{
    self.playerVC.state = ELLPlayViewStateAnimating;
    self.playerVC.beforeBounds = self.playerVC.view.bounds;
    self.playerVC.beforeCenter = self.playerVC.view.center;
    self.playerVC.parentView = self.playerVC.view.superview;
    
    vc.vc = self.playerVC;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.transitioningDelegate = self;
     [self presentViewController:vc animated:YES completion:^{
         self.playerVC.state = ELLPlayViewStateFull;
     }];
    self.controller = vc;
    
}
#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLPlayerCell *cell = (LLPlayerCell *)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    WEAKSELF(weakSelf);
    __weak typeof(cell) weakCell = cell;
    cell.playClick = ^(UIButton *btn){
        __strong typeof (weakCell) strongCell = weakCell;
        NSLog(@"show");
        weakSelf.playerVC.fullScreenBlock = ^(id sender) {
            if(weakSelf.playerVC.state == ELLPlayViewStateSmall){
                [weakSelf enterFullscreen];
            }
        };
        
        weakSelf.playerVC.shrinkScreenBlock = ^(id sender) {
             [weakSelf exitFullScreen];
        };
        [strongCell.contentView addSubview:weakSelf.playerVC.view];
        [weakSelf.playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(strongCell.contentView);
        }];
    };
    if (indexPath.row%4 == 0) {
        cell.playBtn.backgroundColor = [UIColor orangeColor];
    }else if (indexPath.row%4 == 1){
        cell.playBtn.backgroundColor = [UIColor purpleColor];
    }else if (indexPath.row%4 == 2){
        cell.playBtn.backgroundColor = [UIColor redColor];
    }else if (indexPath.row%4 == 3){
        cell.playBtn.backgroundColor = [UIColor greenColor];
    }
    [cell.playBtn setTitle:[NSString stringWithFormat:@"播放%tu",indexPath.row] forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (LLPlayerViewController *)playerVC
{
    if(!_playerVC){
        _playerVC = [[LLPlayerViewController alloc]init];
        _playerVC.contentURL = [NSURL URLWithString:@"http://pl-ali.youku.com/playlist/m3u8?vid=XMzMyMjUwMDcwOA%3D%3D&type=flv&ups_client_netip=3a84b648&ups_ts=1516093099&utid=j6zkEkgIZzgCATqEtkjwuG%2F2&ccode=0502&psid=c644b9c3913aacc07f432f5e7f1b5abc&duration=301&expire=18000&ups_key=6a5fbbb17f0f125c561cf79e304e3094"];
    }
    return _playerVC;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[LLEnterFullScreenTransition alloc] initWithController:self.playerVC];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[LLExitFullScreenTransition alloc] initWithController:self.playerVC];
}

@end
