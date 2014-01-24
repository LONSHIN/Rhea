//
//  RELibraryAPI.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RELibraryAPI.h"
#import "REHTTPClient.h"
#import "RECity.h"
#import "RERecallInfo.h"
#import "REBreakRulesInfo.h"
#import "REBanner.h"


@implementation RELibraryAPI

+ (void)getCitysWithSuccesseedBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    RECityManager *cityManager = [RECityManager sharedManager];
    if (cityManager.citys != nil) {
        succeededBlock(cityManager.citys);
    }else {
        [REHTTPClient getCityDataWithSuccessedBlock:^(NSArray *cityDataArray) {
            NSMutableArray *citys = [[NSMutableArray alloc] init];
            for (NSDictionary *provinceInfo in cityDataArray) {
                NSMutableDictionary *province = [[NSMutableDictionary alloc] init];
                [province setObject:provinceInfo[kKeyCitysProvince] forKey:kKeyCitysProvince];
                
                NSMutableArray *provinceCityArray = [[NSMutableArray alloc] init];
                for (NSDictionary *cityInfo in [provinceInfo objectForKey:kKeyCitysProvinceCity]) {
                    RECity *city = [[RECity alloc] initWithInfo:cityInfo];
                    if (city.status == NO) {
                        continue;
                    }
                    [provinceCityArray addObject:city];
                }
                [province setObject:provinceCityArray forKey:kKeyCitysProvinceCity];
                
                [citys addObject:province];
            }
            cityManager.citys = citys;
            succeededBlock(citys);
        } failedBlock:^(NSError *error) {
            failedBlock(error);
        }];
    }
}


#pragma mark -

+ (NSArray *)getAllSavedCar
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kCarPath];
}


+ (NSInteger)carCount
{
    return [[RELibraryAPI getAllSavedCar] count];
}


+ (BOOL)saveCar:(RECar *)addCar
{
    NSArray *carArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kCarPath];
    NSMutableArray *carList = [[NSMutableArray alloc] init];
    for (RECar *car in carArray) {
        [carList addObject:car];
    }
    [carList addObject:addCar];
    return [NSKeyedArchiver archiveRootObject:carList toFile:kCarPath];
}



+ (BOOL)updateCar:(RECar *)updateCar
{
    NSArray *carArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kCarPath];
    NSMutableArray *carList = [[NSMutableArray alloc] init];
    
    for (RECar *car in carArray) {
        if (![car.guid isEqualToString:updateCar.guid]) {
            [carList addObject:car];
        }
    }
    
    [carList addObject:updateCar];
    return [NSKeyedArchiver archiveRootObject:carList toFile:kCarPath];
}


+ (BOOL)deleteCar:(RECar *)deleteCar
{
    NSArray *carArray = [RELibraryAPI getAllSavedCar];
    NSMutableArray *currentCarArray = [[NSMutableArray alloc] init];
    for (RECar *car in carArray) {
        if (![car.guid isEqualToString:deleteCar.guid]) {
            [currentCarArray addObject:car];
        }
    }
    return [NSKeyedArchiver archiveRootObject:currentCarArray toFile:kCarPath];
}


#pragma mark -

+ (void)getCarTypeList:(void(^)(NSArray *))callBack
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarType" ofType:@"json"];
    NSString *responseObject = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *response = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding]
                                                              options: NSJSONReadingMutableContainers
                                                                error: nil];
    NSMutableArray *carTypeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *info in response) {
        RECarType *carType = [[RECarType alloc] initWithInfo:info];
        [carTypeArray addObject:carType];
    }
    
    callBack(carTypeArray);
}


+ (void)getAbbreviationList:(void(^)(NSArray *abbreviationList))callBack
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Abbreviation" ofType:@"json"];
    NSString *responseObject = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *response = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: nil];
    NSMutableArray *abbreviationList = [[NSMutableArray alloc] init];
    for (NSString *info in response) {
        [abbreviationList addObject:info];
    }
    
    callBack(abbreviationList);
}


#pragma mark -

+ (void)getRecallInfoWithVinCode:(NSString *)vinCode succeededBlock:(void (^)(NSArray *recallArray, NSDictionary *carInfo))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    [REHTTPClient getRecallDataWithVinCode:vinCode succeededBlcok:^(NSArray *responseObject, NSDictionary *carInfo) {
         NSMutableArray *recallInfoArray = [[NSMutableArray alloc] init];
        for (NSDictionary *info in responseObject) {
            RERecallInfo *recallInfo = [[RERecallInfo alloc] initWithInfo:info];
            [recallInfoArray addObject:recallInfo];
        }
        succeededBlock(recallInfoArray, carInfo);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}


#pragma mark - 

+ (void)getBreakRulesInfoWithCar:(RECar *)car succeededBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlcok
{
    [REHTTPClient getBreakRulesDataWithCar:car succeededBlock:^(NSDictionary *responseObject) {
        
        NSMutableArray *breakRulesInfoArray = [[NSMutableArray alloc] init];
        for (NSDictionary *info in responseObject) {
            REBreakRulesInfo  *breakRulesInfo = [[REBreakRulesInfo alloc] initWithInfo:info];
            [breakRulesInfoArray addObject:breakRulesInfo];
        }
        succeededBlock(breakRulesInfoArray);
    } failedBlock:^(NSError *error) {
        failedBlcok(error);
    }];
}


#pragma mark - 

+ (void)getBannerWithSucceededBlock:(void (^)(NSArray *bannerList))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    [REHTTPClient getBannerDataWithSucceededBlock:^(NSArray *responseObject) {
        NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
        for (NSDictionary *info in responseObject) {
            REBanner *banner = [[REBanner alloc] initWithInfo:info];
            [bannerArray addObject:banner];
        }
        succeededBlock(bannerArray);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

@end
