//
//  REBreakRulesInfo.h
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REBreakRulesInfo : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *problem;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *demeritPoints;
@property (nonatomic, copy) NSString *money;

- (id)initWithInfo:(NSDictionary *)info;

@end
