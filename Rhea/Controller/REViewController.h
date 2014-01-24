//
//  REViewController.h
//  Rhea
//
//  Created by Tiger on 13-12-24.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, APOViewControllerShowType) {
    REViewControllerShowTypeUnkonwn,
    REViewControllerShowTypePushed,
    REViewControllerShowTypePresented,
    REViewControllerShowTypePresentedWithCompletionBlock,
};


@interface REViewController : UIViewController

@property (nonatomic, assign) APOViewControllerShowType showType;

- (void)goBack;
- (void)configBackground;

@end
