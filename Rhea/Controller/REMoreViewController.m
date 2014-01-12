//
//  CNSMoreViewController.m
//  Cronus
//
//  Created by Tiger on 13-12-6.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "REMoreViewController.h"
#import "CNSShareManager.h"

@interface REMoreViewController ()
<UIActionSheetDelegate>

@end



@implementation REMoreViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"更多";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configBgViews];
    [self configButtons];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)configBgViews
{
    UIImageView *carView = [UIImageView imageViewWithImageName:@"more_car"];
    carView.frame = CGRectMake(0.0f, [UIScreen mainScreen].bounds.size.height - 64.0f - carView.height, carView.width, carView.height);
    [self.view addSubview:carView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 286, 94.0f)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"858585"];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"您正在使用的是车小弟爱车维护保养信息平台的手机应用。车小弟平台是一家致力于为广大车主提供修车养车全方位专业服务信息的领先平台。感谢您使用车小弟产品，也期望您能继续支持车小弟，我们将努力为您做的更好。";
    label.center = CGPointMake(160.0f, ([UIScreen mainScreen].bounds.size.height - 64.0f - carView.height) / 2.0f);
    [self.view addSubview:label];
}


- (void)configButtons
{
    UIImage *buttonBg = [[UIImage imageNamed:@"orange_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    UIButton *changeCarButton = [UIButton buttonWithText:@"车辆管理" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] target:self action:@selector(handleChangeCarButtonTapped:)];
    [changeCarButton setBackgroundImage:buttonBg forState:UIControlStateNormal];
    changeCarButton.frame = CGRectMake(0.0f, 0.0f, 150.0f, 40.0f);
    changeCarButton.center = CGPointMake(160.0f, [UIScreen mainScreen].bounds.size.height - 150.0f - 64.0f);
    //[self.view addSubview:changeCarButton];
    
    UIButton *shareAppButton = [UIButton buttonWithText:@"分享车小弟" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] target:self action:@selector(handleShareAppButtonTapped:)];
    [shareAppButton setBackgroundImage:buttonBg forState:UIControlStateNormal];
    shareAppButton.frame = CGRectMake(0.0f, 0.0f, 150.0f, 40.0f);
    shareAppButton.center = CGPointMake(160.0f, [UIScreen mainScreen].bounds.size.height - 95.0f - 64.0f);
    [self.view addSubview:shareAppButton];
}


#pragma mark - Button Action

- (void)handleChangeCarButtonTapped:(UIButton *)sender
{

}


- (void)handleShareAppButtonTapped:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享车小弟"
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
