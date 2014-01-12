//
//  RECity.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RECity : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *abbreviation;
@property (nonatomic, assign) BOOL needEngineCode;
@property (nonatomic, assign) BOOL needRegistCode;
@property (nonatomic, assign) BOOL needVinCode;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger engineCodeNumber;
@property (nonatomic, assign) NSInteger registCodeNumber;
@property (nonatomic, assign) NSInteger vinCodeNumber;

- (id)initWithInfo:(NSDictionary *)dict;
+ (RECity *)defaultCity;

@end



@interface RECityManager : NSObject

@property (nonatomic, strong) NSArray *citys;

+ (RECityManager *)sharedManager;

@end

