//
//  REHTTPClient.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REHTTPClient.h"

@implementation REHTTPClient

+ (REHTTPClient *)standardClient
{
    static REHTTPClient *_client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[REHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:kBasicHostURLString]];
    });
    
    return _client;
}


- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
//        [self setDefaultHeader:@"Accept" value:@"text/html"];
    }
    return self;
}


#pragma mark - 

- (void)getCityDataWithSuccessedBlock:(void (^)(NSDictionary *))successedBlock failedBlock:(REFailedBlock)failedBlock
{
    [self postPath:@"query/citys"
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               successedBlock(responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failedBlock(error);
           }];
}

@end
