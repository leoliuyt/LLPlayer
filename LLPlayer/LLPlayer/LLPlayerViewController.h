//
//  LLPlayerViewController.h
//  LLPlayer
//
//  Created by lbq on 16/9/5.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSUInteger, ELayerVideoGravityType) {
    ELayerVideoGravityTypeResize,
    ELayerVideoGravityTypeResizeAspectFill,
    ELayerVideoGravityTypeResizeAspect
};

//NSString * const AVLayerVideoGravityResize;
////        NSString * const AVLayerVideoGravityResizeAspect; //default
////        NSString * const AVLayerVideoGravityResizeAspectFill;
//_playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
@interface LLPlayerViewController : UIViewController

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) ELayerVideoGravityType videoGravityType;

@end
