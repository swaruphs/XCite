//
//  XCiteCacheManager.h
//  XCite
//
//  Created by Swarup on 30/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCiteCacheManager : NSObject

+ (instancetype)sharedInstance;
- (BOOL)isBeaconVisited:(NSString *)identifier;
- (void)saveVisitedBeacon:(NSString *)identifier;
- (NSString *)savedEmail;
- (void)saveEmail:(NSString *)email;
- (void)resetCache;

@end
