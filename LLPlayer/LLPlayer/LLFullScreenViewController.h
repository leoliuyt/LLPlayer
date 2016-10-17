//
//  LLFullScreenViewController.h
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLViewController.h"

@class LLPlayerViewController;
@interface LLFullScreenViewController : LLViewController

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, strong) LLPlayerViewController *videoPlayerVC;

@end
