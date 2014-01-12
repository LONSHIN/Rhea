//
//  RERecallInfo.m
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "RERecallInfo.h"

@implementation RERecallInfo

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.availableTime = [info objectForKey:@"availableTime"];
        self.involvingNumber = [info objectForKey:@"involvingNumber"];
        self.problem = [info objectForKey:@"problem"];
        self.consequence = [info objectForKey:@"consequence"];
        self.fixMeasures = [info objectForKey:@"fixMeasures"];
        self.improveMeasures = [info objectForKey:@"improveMeasures"];
        self.complaints = [info objectForKey:@"complaints"];
        self.ownersNotice = [info objectForKey:@"ownersNotice"];
        self.otherInfo = [info objectForKey:@"otherInfo"];
    }
    return self;
}

@end
