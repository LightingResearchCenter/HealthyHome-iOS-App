//
//  AppDelegate.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/10/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "AppDelegate.h"

#include "TestFlight.h"
#include "GlobalConfig.h"
#import  "ViewControllerHomePage.h"
#import  "TestFairy.h"
#import  "ProgressHUD.h"

@implementation AppDelegate
ViewControllerHomePage *myRootController ;

void uncaughtExceptionHandler(NSException *exception) {
    NSArray *backtrace = [exception callStackSymbols];

    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@"OS: %@. Backtrace:\n%@",
                         version,
                         backtrace];
    
    NSLog(@"App Crashed\r\n %@", message);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

//    [TestFairy begin:@"8ee77962c97d2bad9947b1597810180a62c1dc06"];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    myRootController = [[ViewControllerHomePage alloc] init];
    
    self.window.rootViewController = myRootController;
    [self.window makeKeyAndVisible];
    
#ifdef k_FEATURE_USE_SHAKE_FOR_DEBUG
    [application setApplicationSupportsShakeToEdit:YES];
#endif
    
    
    // registering for remote notifications
    [self registerForRemoteNotification];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark - Core Data Accessors
//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil] ;
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[AppDelegate applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"HealthyHome.sqlite"]];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}




- (void)registerForRemoteNotification {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)purgeDirectory:(NSString *)dirPath
{
    NSLog(@"Purging Directory %@", dirPath);
    NSString *folderPath = dirPath;
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#ifndef DEBUG
    [ProgressHUD showSuccess:@"Restore Feature Not Supported!"];
    return 0;
    
#endif
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];

    NSString *sourcePath = [NSString stringWithFormat:@"%@/%@",inboxPath,dirFiles[0]];
    
    //Copy the passed file to the local Storage
    //Make sure that you can create an archive file
    
    NSString *mySqliteFile = [NSString stringWithFormat:@"%@/HealthyHome.sqlite",
                              documentsDirectory ];
    if ([filemgr fileExistsAtPath: mySqliteFile])
    {
        [filemgr removeItemAtPath:mySqliteFile error:NULL];
    }
    
    NSString *tempFile = [NSString stringWithFormat:@"%@/HealthyHome.sqlite-shm", documentsDirectory ];

    if ([filemgr fileExistsAtPath: tempFile])
    {
        [filemgr removeItemAtPath:tempFile error:NULL];
    }
   
   tempFile = [NSString stringWithFormat:@"%@/HealthyHome.sqlite-wal", documentsDirectory ];
    if ([filemgr fileExistsAtPath: tempFile])
    {
        [filemgr removeItemAtPath:tempFile error:NULL];
    }

    tempFile = [NSString stringWithFormat:@"%@/pacemaker.csv", documentsDirectory ];
    if ([filemgr fileExistsAtPath: tempFile])
    {
        [filemgr removeItemAtPath:tempFile error:NULL];
    }
    
    NSError *error;
    [filemgr copyItemAtPath:sourcePath toPath:mySqliteFile error:&error];
    NSLog([error localizedDescription]);
    [self purgeDirectory:inboxPath];
    [ProgressHUD showSuccess:@"Data Restored !"];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
//    [TestFairy checkpoint:[NSString stringWithFormat:@"Data Restored on %@",dateString]];
    
    
    [managedObjectContext reset];
    for (NSPersistentStore *store in persistentStoreCoordinator.persistentStores) {
        BOOL removed = [persistentStoreCoordinator removePersistentStore:store error:&error];
        
        if (!removed) {
            NSLog(@"Unable to remove persistent store: %@", error);
        }
    }

    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    NSURL *mySqliteURL = [NSURL fileURLWithPath:mySqliteFile];
    NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                  configuration:nil
                                                                                            URL:mySqliteURL
                                                                                        options:options
                                                                                          error:&error];
    if (!persistentStore) {
        NSLog(@"Unable to add new store: %@", error);
    }
    
    [myRootController RefreshLightAndActivityTicker:1];
    [myRootController ReCompute];
    return true;
    

    
}

@end
