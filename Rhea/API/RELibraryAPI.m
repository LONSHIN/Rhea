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
        [[REHTTPClient standardClient] getCityDataWithSuccessedBlock:^(NSDictionary *citysDictionary) {
            NSArray *allKeys = [citysDictionary allKeys];
            NSMutableArray *citys = [[NSMutableArray alloc] init];
            for (NSString *key in allKeys) {
                NSDictionary *provinceInfo = [citysDictionary objectForKey:key];
                
                NSMutableDictionary *province = [[NSMutableDictionary alloc] init];
                [province setObject:provinceInfo[kKeyCitysProvince] forKey:kKeyCitysProvince];
                
                NSMutableArray *provinceCityArray = [[NSMutableArray alloc] init];
                for (NSDictionary *cityInfo in [provinceInfo objectForKey:kKeyCitysProvinceCity]) {
                    RECity *city = [[RECity alloc] initWithInfo:cityInfo];
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
//    NSMutableArray *test = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < 3; i++) {
//        RECar *car = [[RECar alloc] init];
//        car.licensePlateNumber = [NSString stringWithFormat:@"%@%d",@"TigerTest", i];
//        [test addObject:car];
//    }
//    
//    return test;
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kCarPath];
}


+ (NSInteger)carCount
{
    return [[RELibraryAPI getAllSavedCar] count];
}


+ (BOOL)saveCar:(RECar *)addCar
{
    NSMutableArray *carList = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kCarPath]];
    if (carList == nil) {
        carList = [[NSMutableArray alloc] init];
    }
    
    for (RECar *car in carList) {
        if ([car.licensePlateNumber isEqualToString:addCar.licensePlateNumber]) {
            [carList removeObject:car];
        }
    }
    
    [carList addObject:addCar];
    return [NSKeyedArchiver archiveRootObject:carList toFile:kCarPath];
}


+ (BOOL)deleteCar:(RECar *)deleteCar
{
    NSMutableArray *carArray = [[NSMutableArray alloc] initWithArray:[RELibraryAPI getAllSavedCar]];
    for (RECar *car in carArray) {
        if ([car.licensePlateNumber isEqualToString:deleteCar.licensePlateNumber]) {
            [carArray removeObject:car];
        }
    }
    return [NSKeyedArchiver archiveRootObject:carArray toFile:kCarPath];
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


#pragma mark - 

+ (void)getRecallInfoWithVinCode:(NSString *)vinCode succeededBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    [[REHTTPClient standerdRecallClient] getRecallDataWithVinCode:vinCode succeededBlcok:^(NSArray *responseObject) {
         NSMutableArray *recallInfoArray = [[NSMutableArray alloc] init];
        for (NSDictionary *info in responseObject) {
            RERecallInfo *recallInfo = [[RERecallInfo alloc] initWithInfo:info];
            [recallInfoArray addObject:recallInfo];
        }
        succeededBlock(recallInfoArray);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}


#pragma mark - 

+ (void)getBreakRulesInfoWithCar:(RECar *)car succeededBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlcok
{
    [[REHTTPClient standardClient] getBreakRulesDataWithCar:car succeededBlock:^(NSDictionary *responseObject) {
        
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
    [[REHTTPClient standardBannerClient] getBannerDataWithSucceededBlock:^(NSArray *responseObject) {
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
