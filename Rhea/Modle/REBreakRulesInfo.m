//
//  REBreakRulesInfo.m
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REBreakRulesInfo.h"

@implementation REBreakRulesInfo

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.time = [info objectForKey:@"date"];
        self.place = [info objectForKey:@"area"];
        self.problem = [info objectForKey:@"act"];
        self.code = [info objectForKey:@"code"];
        self.demeritPoints = [info objectForKey:@"fen"];
        self.money = [info objectForKey:@"money"];
    }
    return self;
}


@end
