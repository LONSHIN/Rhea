//
//  RERecallDetailViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-3.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECar.h"

@interface RERecallDetailViewController : REViewController

- (id)initWithCar:(RECar *)car;

- (void)updateWithCar:(RECar *)car;

@end

