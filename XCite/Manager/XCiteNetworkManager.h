//
//  XCiteNetworkManager.h
//  XCite
//
//  Created by Swarup on 2/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCiteNetworkManager : NSObject

+(instancetype)sharedInstance;

/**
 *  Send email to the email address. Uses MD5 and Sha1 for encryption.
 *
 *  @param email   email
 *  @param pdfFile pdf file to attach
 */
- (void)sendEmailTo:(NSString *)email withPDF:(NSString *)pdfFile;

/**
 *  Subscribe the user for DeepDive event
 *
 *  @param email email
 *  @param name  name
 */
- (void)subscribeUserWithEmail:(NSString *)email name:(NSString *)name;

@end
