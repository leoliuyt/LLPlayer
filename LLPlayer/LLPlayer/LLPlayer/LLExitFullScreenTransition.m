//
//  LLExitFullScreenTransition.m
//  LLPlayer
//
//  Created by leoliu on 2018/1/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "LLExitFullScreenTransition.h"
@interface LLExitFullScreenTransition()


@property (nonatomic, strong) LLPlayerViewController *vc;

@end
@implementation LLExitFullScreenTransition

- (instancetype)initWithController:(LLPlayerViewController *)vc
{
    self = [super init];
    self.vc = vc;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    if(!toView || !fromView) {
        return;
    }
    // fromView的最终位置
    CGPoint finaleCenter = [transitionContext.containerView convertPoint:self.vc.beforeCenter fromView:nil];
    //将 toView 插入fromView的下面，否则动画过程中不会显示toView
    [transitionContext.containerView insertSubview:toView belowSubview:fromView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        // 让 fromView 返回playView的初始值
        fromView.transform = CGAffineTransformIdentity;
        fromView.center = finaleCenter;
        fromView.bounds = self.vc.beforeBounds;
        
    } completion:^(BOOL finished) {
        // 动画完成后，将playView添加到竖屏界面上
        fromView.transform = CGAffineTransformIdentity;
        fromView.center = finaleCenter;
        fromView.bounds = self.vc.beforeBounds;
//        self.vc.view.frame = self.vc.view.frame;
        self.vc.view.frame = self.vc.beforeBounds;
        [self.vc.parentView addSubview:self.vc.view];
        [self.vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.vc.parentView);
         }];
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}
@end
