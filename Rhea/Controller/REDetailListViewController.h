//
//  REDetailShellViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECar.h"
#import "REDetailViewController.h"

@interface REDetailListViewController : REViewController

- (id)initWithShowType:(REDetailType)type;

@property (nonatomic, strong) RECar *currentShowCar;

@end
