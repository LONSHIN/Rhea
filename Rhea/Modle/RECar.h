//
//  RECar.h
//  Rhea
//
//  Created by Tiger on 13-12-30.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RECity.h"
#import "RECarType.h"

@interface RECar : NSObject

@property (nonatomic, strong) RECity *city;
@property (nonatomic, strong) RECarType *carType;
@property (nonatomic, copy) NSString *engineCode;
@property (nonatomic, copy) NSString *vinCode;
@property (nonatomic, copy) NSString *registCode;
@property (nonatomic, copy) NSString *licensePlateNumber;
@property (nonatomic, copy) NSString *intactVinCode;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *series;
@property (nonatomic, assign) NSInteger breakRulesCount;
@property (nonatomic, assign) NSInteger recallCount;
@property (nonatomic, copy) NSString *guid;

- (void)updateWithCarInfo:(NSDictionary *)info;
- (void)clearCarInfo;
- (void)updateWithCar:(RECar *)car;

@end
