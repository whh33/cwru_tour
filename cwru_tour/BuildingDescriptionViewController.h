//
//  BuildingDescriptionViewController.h
//  cwru_tour
//
//  Created by Eric Vennaro on 4/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BuildingDescriptionViewController : UIViewController <NSFetchedResultsControllerDelegate>



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSEntityDescription *buildingEntity;
@property (strong, nonatomic) NSManagedObject * instanceIndividual;


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *description;

@end