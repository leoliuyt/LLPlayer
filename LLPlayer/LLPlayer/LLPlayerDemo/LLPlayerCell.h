//
//  LLPlayerCell.h
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLPlayerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, copy) void(^playClick)(UIButton *btn);

@end
