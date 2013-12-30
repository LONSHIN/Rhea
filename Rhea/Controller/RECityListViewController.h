//
//  RECityListViewController.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECity.h"

typedef void(^RECityListSelectCityBlock)(RECity *selectCity);

@interface RECityListViewController : REViewController

- (id)initWithSelectCityBlcok:(RECityListSelectCityBlock)selectCityBlcok;

@end
