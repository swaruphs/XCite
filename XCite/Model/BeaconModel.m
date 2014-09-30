//
//  BeaconModel.m
//  iBeacon
//
//  Created by Swarup on 17/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BeaconModel.h"
@import CoreLocation;

@implementation BeaconModel


- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
    if ([[beacon.proximityUUID UUIDString] isEqualToString:[self.uuid UUIDString]] &&
        [beacon.major isEqual: @(self.majorVersion)] &&
        [beacon.minor isEqual: @(self.minorVersion)])
    {
        return YES;
    } else {
        return NO;
    }
}

@end
