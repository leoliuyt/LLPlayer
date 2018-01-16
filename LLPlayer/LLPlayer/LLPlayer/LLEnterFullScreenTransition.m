//
//  LLEnterFullScreenTransition.m
//  LLPlayer
//
//  Created by leoliu on 2018/1/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "LLEnterFullScreenTransition.h"
#import "LLLandscapeLeftViewController.h"
@interface LLEnterFullScreenTransition()<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) LLPlayerViewController *vc;

@end
@implementation LLEnterFullScreenTransition

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
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if(!toView || !toController) {
        return;
    }
    // 计算toView的初始位置
    CGPoint initialCenter = [transitionContext.containerView convertPoint:self.vc.beforeCenter fromView:self.vc.view];
    [transitionContext.containerView addSubview:toView];

    // 将toView的 位置变为初始位置，准备动画
    [toView addSubview:self.vc.view];
    toView.bounds = self.vc.beforeBounds;
    toView.center = initialCenter;
    // 根据屏幕方向的不同选择不同的角度
    if([toController isKindOfClass:[LLLandscapeLeftViewController class]]) {
        toView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    } else {
        toView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        // 将 toView 从设置的初始位置回复到正常位置
        toView.transform = CGAffineTransformIdentity;
        toView.bounds = transitionContext.containerView.bounds;
        toView.center = transitionContext.containerView.center;
    } completion:^(BOOL finished) {
        // 动画完成后再次设置终点状态，防止动画被打断造成BUG
        toView.transform = CGAffineTransformIdentity;
        toView.bounds = transitionContext.containerView.bounds;
        toView.center = transitionContext.containerView.center;
        [transitionContext completeTransition:YES];
    }];

}

@end
