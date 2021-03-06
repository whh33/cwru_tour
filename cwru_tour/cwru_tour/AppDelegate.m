//
//  AppDelegate.m
//  cwru_tour
//
//  Created by Heath Hudgins on 2/22/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "AppDelegate.h"
#import "BuildingsViewController.h"
#import "TourViewController.h"
#import "Building.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyC879ApetypjM5bloekFEKYP9WtsbmVxqU"];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController = tabBarController.viewControllers[3];
    BuildingsViewController *bvController = (BuildingsViewController *)navigationController.topViewController;
    bvController.managedObjectContext = self.managedObjectContext;
    
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

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - load files
- (NSURL *)buildingListFileDirectory
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"buildingList" withExtension:@"txt"];
    return url;
}

- (NSURL *)routesListFileDirectory
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"routesList" withExtension:@"txt"];
    return url;
}


- (void)initBuildingDatabaseFromURL:(NSURL*)url
{
    NSError *error;
    // read everything from text
    NSString * fileContents =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    //trim the last newline charater
    fileContents = [fileContents stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    // first, separate by new line
    NSMutableArray *allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [allLinedStrings removeObjectAtIndex:0];
    
    //then, for each line, create a record in your database
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *buildingEntity = [NSEntityDescription entityForName:@"Building" inManagedObjectContext:self.managedObjectContext];
    
    for (NSString *currentLine in allLinedStrings) {
        NSArray *record = [currentLine componentsSeparatedByString:@"^"];
        
        NSManagedObject *newBuilding = [[NSManagedObject alloc] initWithEntity:buildingEntity insertIntoManagedObjectContext:context];
        
        NSString *buildingName = record[0];
        NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString:record[1]];
        NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString:record[2]];
        NSDecimalNumber *waypointLat = [NSDecimalNumber decimalNumberWithString:record[3]];
        NSDecimalNumber *waypointLon = [NSDecimalNumber decimalNumberWithString:record[4]];
        NSString *description = record[5];
            
        [newBuilding setValue:buildingName forKey:@"name"];
        [newBuilding setValue:latitude forKey:@"latitude"];
        [newBuilding setValue:longitude forKey:@"longitude"];
        [newBuilding setValue:waypointLon forKey:@"waypointLon"];
        [newBuilding setValue:waypointLat forKey:@"waypointLat"];
        [newBuilding setValue:description forKey:@"longDescription"];
    }
    
    // Save the context.
    error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)initRouteDatabaseFromURL:(NSURL*)url
{
    NSError *error;
    NSString * fileContents =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    fileContents = [fileContents stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [allLinedStrings removeObjectAtIndex:0];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *routeEntity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:self.managedObjectContext];
    
    for (NSString *currentLine in allLinedStrings) {
        NSArray *record = [currentLine componentsSeparatedByString:@"^"];
        
        NSManagedObject *newRoute = [[NSManagedObject alloc] initWithEntity:routeEntity insertIntoManagedObjectContext:context];
        
        NSString *routeName = record[0];
        NSString *time = record[1];
        NSString *waypointBuildings = record[2];
        NSString *buildingsInRoute = record[3];
        
        [newRoute setValue:routeName forKey:@"name"];
        [newRoute setValue:time forKey:@"time"];
        [newRoute setValue:waypointBuildings forKeyPath:@"waypointBuildings"];
        [newRoute setValue:buildingsInRoute forKey:@"buildingsInRoute"];
    }
    
    // Save the context.
    error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Building" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cwru_tour.sqlite"];
    
    BOOL alreadyRan = [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyRan"];
                       
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if(!alreadyRan){
        
        NSURL* url = [self buildingListFileDirectory];
        [self initBuildingDatabaseFromURL:url];
        
        url = [self routesListFileDirectory];
        [self initRouteDatabaseFromURL:url];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyRan"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end