//
//  XCiteUserDetailsManager.m
//  XCite
//
//  Created by Swarup on 30/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteCacheManager.h"
#import "JSONStore.h"

#define LAST_SYNC_TIME  @"XCiteLastSyncTime"
#define USER_COLLECTION @"XCiteUserCollection"
#define EMAIL_COLLECTION @"XciteEmailCollection"

@implementation XCiteCacheManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{
        __singleton = [[self alloc] init];
    });
    
    return __singleton;
}

- (BOOL)isBeaconVisited:(NSString *)identifier
{
    JSONStoreCollection *beaconColleciton = [self openBeaconCollection];
    if (![beaconColleciton isValidObject]) {
        [self setUpJSONStore];
        return NO;
    }
    
    BOOL isValid = [self checkForValidity];
    if (!isValid) {
        return NO;
    }
    
    NSArray *visitedBeacons = [beaconColleciton findAllWithOptions:nil error:nil];
    NSDictionary *beaconDic = [visitedBeacons firstObjectWithValue:identifier forKeyPath:@"json.identifier"];
    
    return [beaconDic isValidObject];
}

- (void)saveVisitedBeacon:(NSString *)identifier
{
    if(![identifier isValidObject]) {
        return;
    }
    
    JSONStoreCollection *beaconCollection = [[JSONStoreCollection alloc] initWithName:USER_COLLECTION];
    [beaconCollection setSearchField:@"identifier" withType:JSONStore_String];
    [[JSONStore sharedInstance] openCollections:@[beaconCollection] withOptions:nil error:nil];
    
    NSDictionary *data = @{@"identifier":identifier};
    [beaconCollection addData:@[data] andMarkDirty:NO withOptions:nil error:nil];
    
    NSArray *savedArray = [beaconCollection findAllWithOptions:nil error:nil];
    NSLog(@" saved array %@",savedArray);
    
}

- (NSString *)savedEmail
{
    JSONStoreCollection *emailCollection = [self openEmailCollection];

    BOOL isValid = [self checkForValidity];
    if (!isValid) {
        return nil;
    }
    
    NSArray *emailArray = [emailCollection findAllWithOptions:nil error:nil];
    NSDictionary *emailDic = [emailArray firstObjectOrNil];
    return [emailDic valueForKeyPath:@"json.email"];
    
}

- (void)saveEmail:(NSString *)email
{
    JSONStoreCollection *emailCollection = [[JSONStoreCollection alloc] initWithName:EMAIL_COLLECTION];
    
    [emailCollection setSearchField:@"email" withType:JSONStore_String];
    
    [[JSONStore sharedInstance] openCollections:@[emailCollection] withOptions:nil error:nil];
    
    NSDictionary *dataDic =  @{@"email":email};
    [emailCollection addData:@[dataDic] andMarkDirty:NO withOptions:nil error:nil];
    [[JSONStore sharedInstance] closeAllCollectionsAndReturnError:nil];
    
    [self saveCurrentSyncTime];
}

#pragma mark - Private Methods

- (void)saveCurrentSyncTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:LAST_SYNC_TIME];
}

- (void)setUpJSONStore
{
    //clear all the saved data, if any.
    [[JSONStore sharedInstance] destroyDataAndReturnError:nil];
    
}

- (JSONStoreCollection *)openBeaconCollection
{
    JSONStoreCollection *beaconCollection  = [[JSONStoreCollection alloc] initWithName:USER_COLLECTION];
    [beaconCollection setSearchField:@"identifier" withType:JSONStore_String];
    [[JSONStore sharedInstance] openCollections:@[beaconCollection] withOptions:nil error:nil];
    
    return beaconCollection;
}

- (JSONStoreCollection *)openEmailCollection
{
    JSONStoreCollection *emailCollection  = [[JSONStoreCollection alloc] initWithName:EMAIL_COLLECTION];
    [emailCollection setSearchField:@"email" withType:JSONStore_String];
    [[JSONStore sharedInstance] openCollections:@[emailCollection] withOptions:nil error:nil];
    
    return emailCollection;
    
}


- (JSONStoreCollection *)getEmailCollection
{
    JSONStoreCollection *emailCollection = [[JSONStore sharedInstance] getCollectionWithName:EMAIL_COLLECTION];
    
    return emailCollection;
}

/**
 *  Check if the user defaults value is valid. Values are considered invalid if the sync time is of the previous day.
 *
 *  @return BOOL - whether the values are valid or not.
 */

- (BOOL)checkForValidity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [userDefaults objectForKey:LAST_SYNC_TIME];

    if (![date isValidObject]) {
        return YES;
    }
    
    NSDate *clockZeroDate = [self dateForPastDays:0 fromDate:[NSDate date]];
    if ([date compare:clockZeroDate] == NSOrderedAscending) {
        NSLog(@"old cache. deleting old values");
        [self resetCache];
        return NO;
    }
    
    return YES;
}

/**
 *  Reset the userDefaults.
 */
- (void)resetCache
{
    [NSUserDefaults resetStandardUserDefaults];
    [[JSONStore sharedInstance] closeAllCollectionsAndReturnError:nil];
    [[JSONStore sharedInstance] destroyDataAndReturnError:nil];
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
