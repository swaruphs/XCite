//
//  BeaconManager.m
//  iBeacon
//
//  Created by Swarup on 17/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "BeaconManager.h"
#import "BeaconModel.h"

@interface BeaconManager()

@property (strong, nonatomic) NSMutableArray *beacons;

@end

@implementation BeaconManager

+(instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{
        __singleton = [[self alloc] init];
        [__singleton _init];
    });
 
    return __singleton;
}

- (void)_init
{
    [self getBeacons];
}

- (NSMutableArray *)getBeacons
{
    if (!self.beacons || [self.beacons count] == 0) {
        self.beacons = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"plist"];
        NSMutableArray *beaconArray  = [NSMutableArray arrayWithContentsOfFile:filePath];

        for(NSDictionary * jsonDic in beaconArray) {
            BeaconModel *model = [[BeaconModel alloc] init];
            model.name = [jsonDic objectForKey:@"name"];
            model.uuid = [[NSUUID alloc] initWithUUIDString:[jsonDic objectForKey:@"uuid"]];
            model.majorVersion = [[jsonDic objectForKey:@"major"] unsignedIntegerValue];
            model.minorVersion = [[jsonDic objectForKey:@"minor"] unsignedIntegerValue];
            
            [self.beacons addObject:model];
        }
        
        return self.beacons;
    }
    return self.beacons;
}

@end
