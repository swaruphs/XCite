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


@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic) CLBeaconMajorValue majorVersion;
@property (nonatomic) CLBeaconMinorValue minorVersion;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CLBeacon *lastSeenBeacon;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
