//
//  LLPlayerConfigure.h
//  LLPlayer
//
//  Created by leoliu on 16/10/15.
//  Copyright © 2016年 lbq. All rights reserved.
//

#ifndef LLPlayerConfigure_h
#define LLPlayerConfigure_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define LLPlayerSrcName(file) [@"LLPlayer.bundle" stringByAppendingPathComponent:file]
typedef NS_ENUM(NSUInteger, ELayerVideoGravityType) {
    ELayerVideoGravityTypeResize,
    ELayerVideoGravityTypeResizeAspectFill,
    ELayerVideoGravityTypeResizeAspect
};

#endif /* LLPlayerConfigure_h */
