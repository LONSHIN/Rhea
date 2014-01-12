//
//  RERecallInfo.h
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RERecallInfo : NSObject

@property (nonatomic, copy) NSString *availableTime;
@property (nonatomic, copy) NSString *involvingNumber;
@property (nonatomic, copy) NSString *problem;
@property (nonatomic, copy) NSString *consequence;
@property (nonatomic, copy) NSString *fixMeasures;
@property (nonatomic, copy) NSString *improveMeasures;
@property (nonatomic, copy) NSString *complaints;
@property (nonatomic, copy) NSString *ownersNotice;
@property (nonatomic, copy) NSString *otherInfo;


- (id)initWithInfo:(NSDictionary *)info;

@end
