//
//  REBanner.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REBanner.h"

@implementation REBanner

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.bannerId = [info objectForKey:@"Id"];
        self.jumpLink = [info objectForKey:@"PromotionUrl"];
        self.imageUrl = [info objectForKey:@"ImageUrl"];
        self.title = [info objectForKey:@"PromotionTitle"];
        self.content = [info objectForKey:@"PromotionDetail"];
    }
    return self;
}

@end
