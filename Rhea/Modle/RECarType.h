//
//  RECarType.h
//  Rhea
//
//  Created by Tiger on 13-12-30.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RECarType : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *typeCode;

- (id)initWithInfo:(NSDictionary *)info;
+ (RECarType *)defaultCarType;
- (void)updateWithCarType:(RECarType *)carType;

@end
