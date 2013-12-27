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







@end
