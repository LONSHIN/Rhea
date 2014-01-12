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
        self.needEngineCode = [[dict objectForKey:@"engine"] boolValue];
        self.needVinCode = [[dict objectForKey:@"class"] boolValue];
        self.status = [[dict objectForKey:@"status"] boolValue];
        self.engineCodeNumber = [[dict objectForKey:@"engineno"] integerValue];
        self.vinCodeNumber = [[dict objectForKey:@"classno"] integerValue];
        self.registCodeNumber = [[dict objectForKey:@"registno"] integerValue];
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
    city.needVinCode = YES;
    city.vinCodeNumber = 6;
    
    return city;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"kKeyCodeCityName"];
    [aCoder encodeObject:self.code forKey:@"kKeyCodeCityCode"];
    [aCoder encodeBool:self.needEngineCode forKey:@"kKeyCodeCityNeedEngineCode"];
    [aCoder encodeBool:self.needRegistCode forKey:@"kKeyCodeCityNeedRegistCode"];
    [aCoder encodeObject:self.abbreviation forKey:@"kKeyCodeCityAbbreviation"];
    [aCoder encodeInteger:self.engineCodeNumber forKey:@"kKeyCodeCityEngineCodeNumber"];
    [aCoder encodeInteger:self.registCodeNumber forKey:@"kKeyCodeCityRegistCodeNumber"];
    [aCoder encodeInteger:self.vinCodeNumber forKey:@"kKeyCodeCityVinCodeNumber"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"kKeyCodeCityName"];
        self.code = [aDecoder decodeObjectForKey:@"kKeyCodeCityCode"];
        self.needRegistCode = [aDecoder decodeBoolForKey:@"kKeyCodeCityNeedRegistCode"];
        self.needRegistCode = [aDecoder decodeBoolForKey:@"kKeyCodeCityNeedRegistCode"];
        self.abbreviation = [aDecoder decodeObjectForKey:@"kKeyCodeCityAbbreviation"];
        self.engineCodeNumber = [aDecoder decodeIntegerForKey:@"kKeyCodeCityEngineCodeNumber"];
        self.registCodeNumber = [aDecoder decodeIntegerForKey:@"kKeyCodeCityRegistCodeNumber"];
        self.vinCodeNumber = [aDecoder decodeIntegerForKey:@"kKeyCodeCityVinCodeNumber"];
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