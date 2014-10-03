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
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        
//        NSHTTPURLResponse *response  =  nil;
//        NSError *error =  nil;
//        
//      
//        
//        NSURL *url  = [NSURL URLWithString:urlString];
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//        urlRequest.HTTPMethod =  @"POST";
//        
//        
//        [urlRequest addValue:email forHTTPHeaderField:@"email"];
//        [urlRequest addValue:[timeStamp stringValue] forHTTPHeaderField:@"timestamp"];
//        [urlRequest addValue:hash forHTTPHeaderField:@"hash"];
//        
//        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        if(!error) {
//            NSLog(@"email sent - %@",output);
//        }
//        else {
//            NSLog(@"Got error %@",error);
//        }
//        
//        
//    });
}
@end
