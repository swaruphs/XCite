//
//  BaseNetworkManager.h
//  PromiseWithAfNetworking
//
//  Created by Swarup on 24/6/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetworkManager : NSObject
/**
 *  Singleton shared Instance
 *
 *  @return singleton class object.
 */
+(instancetype)sharedInstance;

/**
 *  AFNetworking GET request
 *
 *  @param URLString  Url string
 *  @param parameters parameters with the request
 *  @param success    success block - returns AFHTTPRequestOperation and response Object
 *  @param failure    failure block
 */

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)PUT:(NSString *)URLString
parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)DELETE:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
