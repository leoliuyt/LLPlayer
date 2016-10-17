//
//  UIView+LL.m
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "UIView+LL.h"

@implementation UIView (LL)

- (UIImage*)ll_snip
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
