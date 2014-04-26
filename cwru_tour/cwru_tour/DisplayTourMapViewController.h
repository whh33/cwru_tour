//
//  DisplayTourMapViewController.h
//  cwru_tour
//
//  Created by Eric Vennaro on 3/8/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface DisplayTourMapViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSEntityDescription *routeEntity;
@property (strong, nonatomic) NSEntityDescription *buildingEntity;
@property (strong, nonatomic) NSManagedObject * instanceIndividual;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIWebView *longDescription;

- (IBAction)displayAnnotation:(id)sender;

@end
