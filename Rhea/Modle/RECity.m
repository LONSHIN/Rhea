//
//  RECity.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECity.h"

@implementation RECity

- (id)initWithInfo:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = [dict objectForKey:@"city_name"];
        self.code = [dict objectForKey:@"city_code"];
        self.abbreviation = [dict objectForKey:@"abbr"];
        self.needRegistCode = [[dict objectForKey:@"registno"] boolValue];
        self.needEngineCode = [[dict objectForKey:@"engineno"] boolValue];
        self.status = [[dict objectForKey:@"status"] boolValue];
    }
    return self;
}

@end



@implementation RECityManager

+ (RECityManager *)sharedManager
{
    static RECityManager *_manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RECityManager alloc] init];
    });
    
    return _manager;
}

@end