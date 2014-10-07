//
//  XCiteCacheManager.h
//  XCite
//
//  Created by Swarup on 30/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCiteCacheManager : NSObject

/**
 *  methiod to access the Singleton class object
 *
 *  @return singleton class object
 */
+ (instancetype)sharedInstance;

/**
 *  Check if the beacon is already visited.
 *
 *  @param identifier Identifier of the beacon
 *
 *  @return Bool value
 */
- (BOOL)isBeaconVisited:(NSString *)identifier;


/**
 *  Mark the beacon as visited
 *
 *  @param identifier Identifier of the beacon
 */
- (void)saveVisitedBeacon:(NSString *)identifier;

/**
 *  Get the saved email
 *
 *  @return email saved
 */
- (NSString *)savedEmail;

/**
 *  Save the email
 *
 *  @param email 
 */
- (void)saveEmail:(NSString *)email;
/**
 *  Reset all stored data. Used for debugging.
 */
- (void)resetCache;

@end
