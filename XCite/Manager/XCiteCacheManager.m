//
//  XCiteUserDetailsManager.m
//  XCite
//
//  Created by Swarup on 30/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteCacheManager.h"

#define USER_DEFAULTS  @"XCiteUserDefaults"

@implementation XCiteCacheManager

+(instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{
        __singleton = [[self alloc] init];
    });
    
    return __singleton;
}

-(BOOL)isBeaconVisited:(NSString *)identifier
{
    BOOL isValid = [self checkForValidity];
    if (isValid) {
        return NO;
    }
    
    NSUserDefaults *userDafaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userDic = [userDafaults objectForKey:USER_DEFAULTS];
    NSMutableArray *beaconArray = [userDic objectForKey:@"visitedBeacons"];
    if (![beaconArray isValidObject] || [beaconArray count] == 0) {
        return NO;
    }
    
    NSSet *beaconSet = [NSMutableSet setWithArray:beaconArray];
    return [beaconSet containsObject:identifier];
}

- (void)saveVisitedBeacon:(NSString *)identifier
{
    if(![identifier isValidObject]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [[userDefaults objectForKey:USER_DEFAULTS] mutableCopy];
    if (![userDic isValidObject]) {
        userDic = [NSMutableDictionary dictionary];
    }

    NSMutableArray *beaconArray  = [[userDic objectForKey:@"visitedBeacons"] mutableCopy];
    if (![beaconArray isValidObject]) {
        beaconArray = [NSMutableArray array];
        
    }
    NSMutableSet *beaconSet  = [NSMutableSet setWithArray:beaconArray];
    [beaconSet addObject:identifier];
    [userDic setObject:[NSDate date] forKey:@"syncDate"];
    [userDic setObject:[beaconSet allObjects] forKey:@"visitedBeacons"];
    [userDefaults setObject:userDic forKey:USER_DEFAULTS];
    [userDefaults synchronize];
    
    NSLog(@"user defaults %@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS]);
}

- (NSString *)savedEmail
{
    BOOL isValid = [self checkForValidity];
    if (isValid) {
        return nil;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userDic = [userDefaults objectForKey:USER_DEFAULTS];
    return [userDic stringForKey:@"email"];
}

- (void)saveEmail:(NSString *)email
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [[userDefaults objectForKey:USER_DEFAULTS] mutableCopy];
    if (![userDic isValidObject]) {
        userDic = [NSMutableDictionary dictionary];
    }
    [userDic setValidObject:email forKey:@"email"];
    [userDic setObject:[NSDate date] forKey:@"syncDate"];
    [userDefaults setObject:userDic forKey:USER_DEFAULTS];
    [userDefaults synchronize];
}

#pragma mark - Private Methods

/**
 *  Check if the user defaults value is valid. Values are considered invalid if the sync time is of the previous day.
 *
 *  @return BOOL - whether the values are valid or not.
 */

- (BOOL)checkForValidity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDefaults objectForKey:USER_DEFAULTS];
    if (![userDic isValidObject] || ![userDic objectForKey:@"syncDate"]) {
        return YES;
    }
    
    NSDate *date  = [userDic objectForKey:@"syncDate"];
    NSDate *clockZeroDate = [self dateForPastDays:0 fromDate:[NSDate date]];
    if ([date compare:clockZeroDate] == NSOrderedAscending) {
        [self resetUserDefaults];
        return YES;
    }
    
    return NO;
}

/**
 *  Reset the userDefaults.
 */
- (void)resetUserDefaults
{
    DLog(@"Reset user defaults");
    [NSUserDefaults resetStandardUserDefaults];
}

/**
 *  Returns the date value of midnight 12 a.m
 *
 *  @param days     Number of days
 *  @param fromDate From Date
 *
 *  @return Date value for midnight 12:00 a.m
 */
- (NSDate *)dateForPastDays:(NSUInteger)days fromDate:(NSDate *)fromDate
{
    NSDate *date =  nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&date
                 interval:NULL forDate:fromDate];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-days];
    date = [calendar dateByAddingComponents:components toDate:date options:0];
    
    return date;
    
}

@end
