//
//  RECar.m
//  Rhea
//
//  Created by Tiger on 13-12-30.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECar.h"

@implementation RECar


- (void)updateWithCarInfo:(NSDictionary *)info
{
    self.brand = [info objectForKey:@"firm"];
    self.series = [info objectForKey:@"model"];
}


- (void)clearCarInfo
{
    self.recallCount = 0;
    self.brand = @"";
    self.series = @"";
}


- (void)updateWithCar:(RECar *)car
{
    [self.city updateWithCity:car.city];
    [self.carType updateWithCarType:car.carType];
    self.engineCode = car.engineCode;
    self.vinCode = car.vinCode;
    self.registCode = car.registCode;
    self.licensePlateNumber = car.licensePlateNumber;
    self.intactVinCode = car.intactVinCode;
    self.brand = car.brand;
    self.series = car.series;
    self.breakRulesCount = car.breakRulesCount;
    self.recallCount = car.recallCount;
    self.guid = car.guid;
}


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


- (NSString *)engineCode
{
    if (_engineCode == nil) {
        _engineCode = @"";
    }
    return _engineCode;
}


- (NSString *)vinCode
{
    if (_vinCode == nil) {
        _vinCode = @"";
    }
    return _vinCode;
}


- (NSString *)registCode
{
    if (_registCode == nil) {
        _registCode = @"";
    }
    return _registCode;
}


- (NSString *)licensePlateNumber
{
    if (_licensePlateNumber == nil) {
        _licensePlateNumber = @"";
    }
    return _licensePlateNumber;
}


- (NSString *)intactVinCode
{
    if (_intactVinCode == nil) {
        _intactVinCode = @"";
    }
    return _intactVinCode;
}


- (NSString *)series
{
    if (_series == nil) {
        _series = @"";
    }
    return _series;
}


- (NSString *)brand
{
    if (_brand == nil) {
        _brand = @"";
    }
    return _brand;
}


- (NSString *)guid
{
    if (_guid == nil || [_guid isEqualToString:@""]) {
        _guid = [NSString GUID];
    }
    return _guid;
}


- (id)init
{
    if (self = [super init]) {
        self.guid = [NSString GUID];
    }
    return self;
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
    [aCoder encodeObject:self.brand forKey:@"kKeyCodeBrand"];
    [aCoder encodeObject:self.series forKey:@"kKeyCodeSeries"];
    [aCoder encodeInteger:self.breakRulesCount forKey:@"kKeyBreakRulesCount"];
    [aCoder encodeInteger:self.recallCount forKey:@"kKeyRecallCount"];
    [aCoder encodeObject:self.guid forKey:@"kKeyCountCarUdid"];
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
        self.series = [aDecoder decodeObjectForKey:@"kKeyCodeSeries"];
        self.brand = [aDecoder decodeObjectForKey:@"kKeyCodeBrand"];
        self.breakRulesCount = [aDecoder decodeIntegerForKey:@"kKeyBreakRulesCount"];
        self.recallCount = [aDecoder decodeIntegerForKey:@"kKeyRecallCount"];
        self.guid = [aDecoder decodeObjectForKey:@"kKeyCountCarUdid"];
    }
    return self;
}

@end
