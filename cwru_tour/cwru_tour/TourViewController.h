//
//  TourViewController.h
//  cwru_tour
//
//  Created by Heath Hudgins on 2/28/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TourViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *TourButton;
@property (weak, nonatomic) IBOutlet UIButton *FreeRoamButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

- (IBAction)launchWeb:(UIButton *)sender;

@end
