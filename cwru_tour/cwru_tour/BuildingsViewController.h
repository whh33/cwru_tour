//
//  BuildingsViewController.h
//  cwru_tour
//
//  Created by Sean Corcoran on 2/23/14.
//  Copyright (c) 2014 EECS397. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BuildingsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSEntityDescription *buildingEntity;

@end