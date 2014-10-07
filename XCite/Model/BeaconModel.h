//
//  BeaconModel.h
//  iBeacon
//
//  Created by Swarup on 17/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface BeaconModel : NSObject


@property (nonatomic, strong) NSUUID *uuid; // uuid
@property (nonatomic) CLBeaconMajorValue majorVersion; // major version
@property (nonatomic) CLBeaconMinorValue minorVersion; // minor version
@property (nonatomic, strong) NSString *name; // beacon identifier
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CLBeacon *lastSeenBeacon;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
