//
//  REAddCarViewController.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECar.h"

@interface REAddCarViewController : REViewController

- (id)initWithCar:(RECar *)car succeededBlock:(REAddCarSucceededBlcok)succeededBlock;

@end
