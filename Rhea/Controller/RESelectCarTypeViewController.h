//
//  RESelectCarTypeViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECarType.h"


@interface RESelectCarTypeViewController : REViewController

- (id)initWithSelectBlock:(void (^)(RECarType *))block;

@end
