//
//  BaseNetworkManager.m
//  PromiseWithAfNetworking
//
//  Created by Swarup on 24/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BaseNetworkManager.h"


@interface BaseNetworkManager()
@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;
@end

@implementation BaseNetworkManager

+(instancetype)sharedInstance
{
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_SERVER_HOST]];
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:URLString parameters:parameters success:success failure:failure];
}


-(void)PUT:(NSString *)URLString
parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager PUT:URLString parameters:parameters success:success failure:failure];
}

-(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager POST:URLString parameters:parameters success:success failure:failure];
}

-(void)DELETE:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager DELETE:URLString parameters:parameters success:success failure:failure];
}

@end


