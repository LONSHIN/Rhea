//
//  REAbbreviationListViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-22.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"

typedef void(^RESelectAbbreviationBlock)(NSString *abbreviation);

@interface REAbbreviationListViewController : REViewController

- (id)initWithSelectBlock:(RESelectAbbreviationBlock)block;

@end
