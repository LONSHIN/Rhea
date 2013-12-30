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
- (BOOL)saveCar:(RECar *)car;

@end
