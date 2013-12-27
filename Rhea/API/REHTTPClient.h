//
//  REHTTPClient.h
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "AFHTTPClient.h"

@interface REHTTPClient : AFHTTPClient

+ (REHTTPClient *)standardClient;
- (id)initWithBaseURL:(NSURL *)url;

- (void)getCityDataWithSuccessedBlock:(void (^)(NSDictionary *citysDictionary))successedBlock failedBlock:(REFailedBlock)failedBlock;

@end
