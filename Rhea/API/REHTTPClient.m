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


+ (REHTTPClient *)standerdRecallClient
{
    static REHTTPClient *_client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[REHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:kBasicRecallHostURLString]];
    });
    
    return _client;
}


+ (REHTTPClient *)standardBannerClient
{
    static REHTTPClient *_client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[REHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBasicBannerHostURLString]];
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


- (void)getBreakRulesDataWithCar:(RECar *)car succeededBlock:(void (^)(NSDictionary *))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
//    NSDictionary *parameters = @{@"token": kAPIToken, @"city" : car.city.code, @"hphm" : car.licensePlateNumber, @"engineno" : car.engineCode, @"classno" : car.vinCode, @"registno" : car.registCode};
    
    NSDictionary *parameters = @{@"token": kAPIToken, @"city" : @"ZJ_HZ", @"hphm" : @"浙A29q82", @"engineno" : @"", @"classno" : @"149913", @"registno" : @"", @"hpzl" : @"02"};
    
    [self postPath:@"query/json"
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSInteger status = [[responseObject objectForKey:@"errorCode"] integerValue];
               if (status == 0) {
                   succeededBlock([responseObject objectForKey:@"lists"]);
               }else {
                   NSString *message;
                   if (status == 1) {
                       message = @"授权码不正确/停⽤";
                   }else if (status == 2) {
                       message = @"本⽇日最⼤大查询次数已到";
                   }else if (status == 3) {
                       message = @"查询超时";
                   }else if (status == 4) {
                       message = @"请求参数不符合城市列表中的规范";
                   }else if (status == 5) {
                       message = @"查询城市不存在/已下线";
                   }else if (status == 6) {
                       message = @"车牌号/发动机/车架号/证书号不正确";
                   }else if (status == 7) {
                       message = @"数据源正在维护";
                   }else {
                       message = @"未知错误";
                   }
                   NSError *error = [NSError errorWithDomain:@"com.chexiaodi.rhea" code:999 userInfo:@{NSLocalizedDescriptionKey : message}];
                   failedBlock(error);
               }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failedBlock(error);
           }];
}


- (void)getRecallDataWithVinCode:(NSString *)vinCode succeededBlcok:(void(^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    [self setDefaultHeader:@"Accept" value:@"text/html"];
    NSDictionary *parameters = @{@"vin": vinCode};
    [self postPath:@""
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options: NSJSONReadingMutableContainers
                                                                           error: nil];

               NSInteger errorCode = [[response objectForKey:@"errorCode"] integerValue];
               
               if (errorCode == 1) {
                   NSLog(@"error:vin码格式错误");
                   NSError *error = [NSError errorWithDomain:@"com.chexiaodi.rhea" code:999 userInfo:@{NSLocalizedDescriptionKey : @"vin码格式错误"}];
                   failedBlock(error);
               }else {
                   succeededBlock([response objectForKey:@"recallInfo"]);
               }

           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"error %@", error);
               failedBlock(error);
           }];
}


- (void)getBannerDataWithSucceededBlock:(void (^)(NSArray *))succeededBlock failedBlock:(REFailedBlock)failedBlock
{
    [self setDefaultHeader:@"Accept" value:@"text/html"];
    NSDictionary *parameters = @{@"UserAgent": @"IOS/0.9.1"};
    [self postPath:@"promotionlist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options: NSJSONReadingMutableContainers
                                                                    error: nil];
        
        NSInteger result = [[response objectForKey:@"Result"] integerValue];
        if (result == 0) {
            succeededBlock([[response objectForKey:@"Content"] objectForKey:@"PromotionList"]);
        }else {
            NSError *error = [NSError errorWithDomain:@"com.chexiaodi.rhea" code:999 userInfo:@{NSLocalizedDescriptionKey : @"获取banner数据失败"}];
            failedBlock(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
}

@end
