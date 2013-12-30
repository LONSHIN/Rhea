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

+ (RECity *)defaultCity
{
    RECity *city = [[RECity alloc] init];
    city.name = @"杭州";
    city.code = @"ZJ_HZ";
    city.abbreviation = @"浙";
    city.needEngineCode = NO;
    city.needRegistCode = NO;
    
    return city;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"kKeyCodeCityName"];
    [aCoder encodeObject:self.code forKey:@"kKeyCodeCityCode"];
    [aCoder encodeBool:self.needEngineCode forKey:@"kKeyCodeCityNeedEngineCode"];
    [aCoder encodeBool:self.needRegistCode forKey:@"kKeyCodeCityNeedRegistCode"];
    [aCoder encodeObject:self.abbreviation forKey:@"kKeyCodeCityAbbreviation"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"kKeyCodeCityName"];
        self.code = [aDecoder decodeObjectForKey:@"kKeyCodeCityCode"];
        self.needRegistCode = [aDecoder decodeBoolForKey:@"kKeyCodeCityNeedRegistCode"];
        self.needRegistCode = [aDecoder decodeBoolForKey:@"kKeyCodeCityNeedRegistCode"];
        self.abbreviation = [aDecoder decodeObjectForKey:@"kKeyCodeCityAbbreviation"];
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