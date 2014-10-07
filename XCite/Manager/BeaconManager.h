//
//  BeaconManager.h
//  iBeacon
//
//  Created by Swarup on 17/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconManager : NSObject

+(instancetype)sharedInstance;

/**
 *  get all beacons from the plist
 *
 *  @return BeaconModel array.
 */
- (NSMutableArray *)getBeacons;

@end
