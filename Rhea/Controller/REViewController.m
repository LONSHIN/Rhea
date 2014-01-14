//
//  REViewController.m
//  Rhea
//
//  Created by Tiger on 13-12-24.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RENavigationController.h"

@interface REViewController ()
<UIGestureRecognizerDelegate>

@end



@implementation REViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self congfigGoBackButton];
    [self basicSetting];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!kSystemVersionPriorToIOS7) {
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}


- (void)congfigGoBackButton
{
    __weak REViewController *weakSelf = self;
    [RACObserve(self, showType) subscribeNext:^(NSString *newName) {
        if (weakSelf.showType != REViewControllerShowTypeUnkonwn) {
            UIButton *backButton = [UIButton buttonWithImageName:@"item_back_normal"
                                            highlightedImageName:@"item_back_highlighted"
                                                           title:@""
                                                          target:weakSelf
                                                          action:@selector(goBack)];
            weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
    }];
}


- (void)basicSetting
{
    if (!kSystemVersionPriorToIOS7) {
        //        self.navigationController.navigationBar.translucent = NO;
        //        self.extendedLayoutIncludesOpaqueBars = NO;
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"41484d"];
    }else {
        UIImage *barBackgroundView = [[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)];
        [self.navigationController.navigationBar setBackgroundImage:barBackgroundView forBarMetrics:UIBarMetricsDefault];
    }
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)goBack
{
    if (self.showType == REViewControllerShowTypePushed) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.showType == REViewControllerShowTypePresented){
        [self dismissModalViewControllerAnimated:YES];
    }else if (self.showType == REViewControllerShowTypePresentedWithCompletionBlock){
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}


- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    [super presentModalViewController:modalViewController animated:animated];
    if ([modalViewController isKindOfClass:[RENavigationController class]]) {
        UIViewController *controller = [[(RENavigationController *)modalViewController viewControllers] objectAtIndex:0];
        if (controller) {
            if ([controller isKindOfClass:[REViewController class]]) {
                [(REViewController *)controller setShowType:REViewControllerShowTypePresented];
            }
        }
    }else if ([modalViewController isKindOfClass:[REViewController class]]){
        REViewController *controller = (REViewController *)modalViewController;
        [controller setShowType:REViewControllerShowTypePresented];
    }
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    if ([viewControllerToPresent isKindOfClass:[RENavigationController class]]) {
        UIViewController *controller = [[(RENavigationController *)viewControllerToPresent viewControllers] objectAtIndex:0];
        if (controller) {
            if ([controller isKindOfClass:[REViewController class]]) {
                [(REViewController *)controller setShowType:REViewControllerShowTypePresentedWithCompletionBlock];
            }
        }
    }else if ([viewControllerToPresent isKindOfClass:[REViewController class]]){
        REViewController *controller = (REViewController *)viewControllerToPresent;
        [controller setShowType:REViewControllerShowTypePresentedWithCompletionBlock];
    }
}

@end
