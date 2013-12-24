//
//  RENavigationController.m
//  Rhea
//
//  Created by Tiger on 13-12-24.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RENavigationController.h"

@interface RENavigationController ()

@end



@implementation RENavigationController

- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if ([viewController isKindOfClass:[REViewController class]]) {
        if (!([[self viewControllers] objectAtIndex:0] == viewController)) {
            [(REViewController *)viewController setShowType:REViewControllerShowTypePushed];
            //viewController.hidesBottomBarWhenPushed = YES;
        }
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
