//
//  RECar.m
//  Rhea
//
//  Created by Tiger on 13-12-30.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECar.h"

@implementation RECar

- (RECity *)city
{
    if (_city == nil) {
        _city = [RECity defaultCity];
    }
    return _city;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.engineCode forKey:@"kKeyCodeCarEngineCode"];
    [aCoder encodeObject:self.vinCode forKey:@"kKeyCodeCarVinCode"];
    [aCoder encodeObject:self.registCode forKey:@"kKeyCodeCarRegistCode"];
    [aCoder encodeObject:self.licensePlateNumber forKey:@"kKeyCodeCarLicensePlateNumber"];
    [aCoder encodeObject:self.carTypeCode forKey:@"kKeyCodeCarTypeCode"];
    [aCoder encodeObject:self.city forKey:@"kKeyCodeCarCity"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.engineCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarEngineCode"];
        self.vinCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarVinCode"];
        self.registCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarRegistCode"];
        self.licensePlateNumber = [aDecoder decodeObjectForKey:@"kKeyCodeCarLicensePlateNumber"];
        self.carTypeCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarTypeCode"];
        self.city = [aDecoder decodeObjectForKey:@"kKeyCodeCarCity"];
    }
    return self;
}

@end
