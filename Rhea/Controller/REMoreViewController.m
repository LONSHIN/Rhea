//
//  CNSMoreViewController.m
//  Cronus
//
//  Created by Tiger on 13-12-6.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "REMoreViewController.h"
#import "CNSShareManager.h"
#import "REManageCarViewController.h"

@interface REMoreViewController ()
<UIActionSheetDelegate>

@end



@implementation REMoreViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"更多";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configBackground];
    [self configBgViews];
    [self configButtons];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)configBgViews
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 40.0f, 286, 110.0f)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"       车小弟违章查询召回查询是车小弟旗下的一款汽车违章及车辆召回查询工具。车小弟致力于为光大车主提供修车养车用车全方位专业服务的领先平台。\n       感谢您使用车小弟，车小弟将为您做的更好！";
    [self.view addSubview:label];
}


- (void)configButtons
{
    UIImage *buttonBg = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 3.0f, 2.0f, 3.0f)];
    
    UIButton *changeCarButton = [UIButton buttonWithText:@"车辆管理" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] target:self action:@selector(handleManageCarButtonTapped:)];
    [changeCarButton setBackgroundImage:buttonBg forState:UIControlStateNormal];
    changeCarButton.frame = CGRectMake(0.0f, 0.0f, 150.0f, 40.0f);
    changeCarButton.center = CGPointMake(160.0f, [UIScreen mainScreen].bounds.size.height - (kScreenIs4InchRetina?150.0f:130.0f) - 64.0f);
    [self.view addSubview:changeCarButton];
    
    UIButton *shareAppButton = [UIButton buttonWithText:@"分享给好友" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] target:self action:@selector(handleShareAppButtonTapped:)];
    [shareAppButton setBackgroundImage:buttonBg forState:UIControlStateNormal];
    shareAppButton.frame = CGRectMake(0.0f, 0.0f, 150.0f, 40.0f);
    shareAppButton.center = CGPointMake(160.0f, [UIScreen mainScreen].bounds.size.height - (kScreenIs4InchRetina?95.0f:75.0f) - 64.0f);
    [self.view addSubview:shareAppButton];
}


#pragma mark - Button Action

- (void)handleManageCarButtonTapped:(UIButton *)sender
{
    REManageCarViewController *manageVC = [[REManageCarViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
}


- (void)handleShareAppButtonTapped:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"微信朋友圈", @"微信好友",nil];
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[CNSShareManager manager] shareApplicationInfoToWeChatTimeLine];
    }else if (buttonIndex == 1){
        [[CNSShareManager manager] shareApplicationInfoToWeChatSession];
    }
}


#pragma mark - Notification

- (void)handleChangeCarNotification:(NSNotification *)sender
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
