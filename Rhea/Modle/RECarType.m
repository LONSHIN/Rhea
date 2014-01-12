//
//  RECarType.m
//  Rhea
//
//  Created by Tiger on 13-12-30.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECarType.h"

@implementation RECarType

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.name = [info objectForKey:@"name"];
        self.typeCode = [info objectForKey:@"id"];
    }
    return self;
}


+ (RECarType *)defaultCarType
{
    RECarType *carType = [[RECarType alloc] init];
    carType.name = @"⼩型车";
    carType.typeCode = @"02";
    
    return carType;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"kKeyCodeCarTypeName"];
    [aCoder encodeObject:self.typeCode forKey:@"kKeyCodeCarTypeCode"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"kKeyCodeCarTypeName"];
        self.typeCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarTypeCode"];
    }
    return self;
}

@end
