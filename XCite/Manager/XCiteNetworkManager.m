//
//  XCiteNetworkManager.m
//  XCite
//
//  Created by Swarup on 2/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteNetworkManager.h"
#import "NSString+Additions.h"
#import <PromiseKit/Promise.h>
#import "NSURLConnection+PromiseKit.h"

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
    NSString *md5PDF = [[NSString stringWithFormat:@"%@.pdf",pdfFile] md5];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",API_EMAIL,md5PDF];
    NSDate *dateNow = [NSDate date];
    NSNumber *timeStamp = [NSNumber numberWithLong:[dateNow timeIntervalSince1970]];
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@%@",email,@"secret",timeStamp];
    NSString *hash = [stringToHash sha1];
    
    NSDictionary *params = @{@"email":email,
                             @"timestamp":timeStamp,
                             @"hash":hash};
    
    [NSURLConnection POST:urlString formURLEncodedParameters:params].then(^(id response){
        
    }).catch(^ (NSError *error){
        NSLog(@"got error while sending email - %@",error);
    });
}

- (void)subscribeUserWithEmail:(NSString *)email name:(NSString *)name
{
    if (!name || !email) {
        return;
    }
    
    NSDictionary *params = @{
                             @"email":email,
                             @"name":name
                             };
    
    [NSURLConnection GET:API_SUBSCRIBE query:params].then(^(id response){
        NSLog(@"user subscribed successfully ! %@",response);
    }).catch(^ (NSError *error){
        NSLog(@"got error while sending email - %@",error);
    });
}
@end
