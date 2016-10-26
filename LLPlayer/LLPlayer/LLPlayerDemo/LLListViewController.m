//
//  LLListViewController.m
//  LLPlayer
//
//  Created by lbq on 16/10/17.
//  Copyright © 2016年 lbq. All rights reserved.
//

#import "LLListViewController.h"
#import "LLFullScreenViewController.h"
#import "LLPlayerCell.h"
#import "UIView+LL.h"
#import "LLNavigationController.h"

@interface LLListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLPlayerCell *cell = (LLPlayerCell *)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    cell.playClick = ^(UIButton *btn){
        NSLog(@"show");
        LLFullScreenViewController *vc = [[LLFullScreenViewController alloc]init];
        vc.bgImage = [LLAppDelegate.window ll_snip];
        vc.originalView = btn;
        LLNavigationController *nav = [[LLNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
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


@end
