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


- (RECarType *)carType
{
    if (_carType == nil) {
        _carType = [RECarType defaultCarType];
    }
    return _carType;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.engineCode forKey:@"kKeyCodeCarEngineCode"];
    [aCoder encodeObject:self.vinCode forKey:@"kKeyCodeCarVinCode"];
    [aCoder encodeObject:self.registCode forKey:@"kKeyCodeCarRegistCode"];
    [aCoder encodeObject:self.licensePlateNumber forKey:@"kKeyCodeCarLicensePlateNumber"];
    [aCoder encodeObject:self.carType forKey:@"kKeyCodeCarType"];
    [aCoder encodeObject:self.city forKey:@"kKeyCodeCarCity"];
    [aCoder encodeObject:self.intactVinCode forKey:@"kKeyCodeIntactVinCode"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.engineCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarEngineCode"];
        self.vinCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarVinCode"];
        self.registCode = [aDecoder decodeObjectForKey:@"kKeyCodeCarRegistCode"];
        self.licensePlateNumber = [aDecoder decodeObjectForKey:@"kKeyCodeCarLicensePlateNumber"];
        self.carType = [aDecoder decodeObjectForKey:@"kKeyCodeCarType"];
        self.city = [aDecoder decodeObjectForKey:@"kKeyCodeCarCity"];
        self.intactVinCode = [aDecoder decodeObjectForKey:@"kKeyCodeIntactVinCode"];
    }
    return self;
}

@end
