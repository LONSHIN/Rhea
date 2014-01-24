//
//  REInputVinCodeViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-17.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECar.h"


@interface REInputVinCodeViewController : REViewController

- (id)initWithCar:(RECar *)car succeededBlock:(REAddCarSucceededBlcok)succeededBlcok;

@end
