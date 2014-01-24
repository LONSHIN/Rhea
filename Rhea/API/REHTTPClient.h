//
//  REHTTPClient.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "AFHTTPClient.h"
#import "RECar.h"

@interface REHTTPClient : AFHTTPClient

+ (void)getCityDataWithSuccessedBlock:(void (^)(NSArray *cityDataArray))successedBlock failedBlock:(REFailedBlock)failedBlock;
+ (void)getBreakRulesDataWithCar:(RECar *)car succeededBlock:(void (^)(NSDictionary *))succeededBlock failedBlock:(REFailedBlock)failedBlock;

+ (void)getRecallDataWithVinCode:(NSString *)vinCode succeededBlcok:(void(^)(NSArray *recallInfo, NSDictionary *carInfo))succeededBlock failedBlock:(REFailedBlock)failedBlock;

+ (void)getBannerDataWithSucceededBlock:(void(^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlock;

@end
