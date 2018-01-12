//
//  LLExitFullScreenTransition.h
//  LLPlayer
//
//  Created by leoliu on 2018/1/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLPlayerViewController.h"
@interface LLExitFullScreenTransition : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithController:(LLPlayerViewController *)vc;
@end
