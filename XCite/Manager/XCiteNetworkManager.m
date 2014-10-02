//
//  XCiteNetworkManager.m
//  XCite
//
//  Created by Swarup on 2/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteNetworkManager.h"
#import "BaseNetworkManager.h"
#import "NSString+Additions.h"

@implementation XCiteNetworkManager

+(instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{
        __singleton = [[self alloc] init];
    });
    
    return __singleton;
}

- (void)sendEmailTo:(NSString *)email withPDF:(NSString *)pdfFile
{
    
    NSString *md5PDF = [pdfFile md5];
    NSString *url = [NSString stringWithFormat:@"%@/%@",API_EMAIL,md5PDF];
    
    NSDate *dateNow = [NSDate date];
    NSNumber *timeStamp = [NSNumber numberWithDouble:[dateNow timeIntervalSince1970]];
    
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@%@",email,@"secret",timeStamp];
    NSString *hash = [stringToHash sha1];
    NSDictionary *params = @{@"email":md5PDF,
                             @"timestamp":timeStamp,
                             @"hash":hash};
    
    [[BaseNetworkManager sharedInstance] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response object %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"erroor %@",error);
    }];
}
@end
