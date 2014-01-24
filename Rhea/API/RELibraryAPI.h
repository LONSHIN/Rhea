//
//  RELibraryAPI.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RECar.h"

@interface RELibraryAPI : NSObject

+ (void)getCitysWithSuccesseedBlock:(void(^)(NSArray *citys))succeededBlock failedBlock:(REFailedBlock)failedBlock;

+ (NSArray *)getAllSavedCar;
+ (BOOL)saveCar:(RECar *)car;
+ (BOOL)updateCar:(RECar *)updateCar;
+ (NSInteger)carCount;
+ (BOOL)deleteCar:(RECar *)car;

+ (void)getCarTypeList:(void(^)(NSArray *))callBack;

+ (void)getRecallInfoWithVinCode:(NSString *)vinCode succeededBlock:(void (^)(NSArray *recallArray, NSDictionary *carInfo))succeededBlock failedBlock:(REFailedBlock)failedBlock;

+ (void)getBreakRulesInfoWithCar:(RECar *)car succeededBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlcok;

+ (void)getAbbreviationList:(void(^)(NSArray *abbreviationList))callBack;

+ (void)getBannerWithSucceededBlock:(void (^)(NSArray *bannerList))succeededBlock failedBlock:(REFailedBlock)failedBlock;

@end
