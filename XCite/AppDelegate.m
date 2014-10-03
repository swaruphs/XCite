//
//  AppDelegate.m
//  XCite
//
//  Created by Swarup on 24/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XCiteVideoPlayerViewController.h"
#import "XCitePDFViewController.h"

@interface AppDelegate ()<ESTBeaconManagerDelegate>

@property (strong, nonatomic) ESTBeaconManager *beaconManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    ViewController *rootController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:rootController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UILocalNotifications

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        NSString *identifier = [notification.userInfo stringForKey:@"identifier"];
        [[XCiteCacheManager sharedInstance] saveVisitedBeacon:identifier];
        [self showHomeScreenAndPushVideoPlayerWithIdentifier:identifier];
    }
}

#pragma mark Beacon Manager Delegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Entered region of beacon with identifier %@",region.identifier);
    NSArray *allBeacons = [[BeaconManager sharedInstance] getBeacons];
    BeaconModel *beaconModel =  [allBeacons firstObjectWithValue:region.identifier forKeyPath:@"name"];
    if ([beaconModel isValidObject]) {
        NSArray *allModels = [[DataManager sharedInstance] getAllModels];
        XCiteModel *model = [allModels firstObjectWithValue:beaconModel.name forKeyPath:@"identifier"];
        if ([model isValidObject]) {
            [self showLocalNotificationsForIndex:model];
        }
    }
    
  
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Beacon exited the region %@",region.identifier);
}

#pragma mark Private APIs

- (void)showLocalNotificationsForIndex:(XCiteModel *)model
{
    BOOL alreadyVisited = [[XCiteCacheManager sharedInstance] isBeaconVisited:model.identifier];
    if (alreadyVisited) {
        NSLog(@"beacon already visited");
        return;
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody            = [NSString stringWithFormat:@"%@\n%@",model.notificationTitle,model.notificationSubTitle];
    notification.soundName            = @"Default";
    notification.userInfo             = @{@"identifier":model.identifier};
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)showHomeScreenAndPushVideoPlayerWithIdentifier:(NSString *)identifier
{
    ViewController *rootController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
  
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:rootController];
    self.window.rootViewController        = navController;
    
    NSArray *allModels = [[DataManager sharedInstance] getAllModels];
    XCiteModel *model = [allModels firstObjectWithValue:identifier forKeyPath:@"identifier"];
    if ([model isValidObject]) {
     
        NSUInteger index = [allModels indexOfObject:model];
        rootController.selectedIndex = index;
        XCiteVideoPlayerViewController *controller = [[XCiteVideoPlayerViewController alloc] initWithNibName:@"XCiteVideoPlayerViewController" bundle:nil];
        controller.model = model;
        controller.moveToPDFOnCompletion = YES;
        [navController pushViewController:controller animated:FALSE];
    }
}

@end
