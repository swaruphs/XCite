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

- (void)sendEmailTo:(NSString *)email withPDF:(NSString *)pdfFile;

@end
