//
//  FreeRoamViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 3/8/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "FreeRoamViewController.h"
#import "Building.h"
@interface FreeRoamViewController ()

@end

@implementation FreeRoamViewController{
    bool firstLocationUpdate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //declare core data
    self.buildingEntity = [NSEntityDescription entityForName:@"Building" inManagedObjectContext:self.managedObjectContext];
    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:self.buildingEntity];
//
//    NSError *error = nil;
//    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//    NSArray *sortDescriptors = @[sortDescriptor];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsController = aFetchedResultsController;
    
    //start map setup
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.995602
                                                            longitude:-78.902153
                                                                 zoom:13];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeHybrid;
    self.mapView.indoorEnabled = YES;
    self.mapView.accessibilityElementsHidden = NO;
    self.mapView.settings.scrollGestures = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    // Listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    [self loadAnnotations];
}
- (void)dealloc {
    [self.mapView removeObserver:self
                      forKeyPath:@"myLocation"
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                             zoom:14];
    }
}

- (void)loadAnnotations {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.buildingEntity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Building *building in results) {
        GMSMarker *buildingMarker = [GMSMarker markerWithPosition:(CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]))];
        buildingMarker.title = building.name;
        buildingMarker.map  = self.mapView;
        self.view = self.mapView;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
