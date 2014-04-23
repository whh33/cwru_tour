//
//  FreeRoamViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 3/8/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "FreeRoamViewController.h"
#import "Building.h"
@interface FreeRoamViewController ()<GMSMapViewDelegate>

@end

@implementation FreeRoamViewController{
    bool firstLocationUpdate;
    GMSMapView *mapView_;
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
    CGRect frame = self.view.bounds;
    frame.size.height = 360 ;
    frame.origin.y= 160;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35
                                                            longitude:-78
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:frame camera:camera];
    mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    [self.view addSubview:mapView_];
    [self loadAnnotations];
}
- (void)dealloc {
    [mapView_ removeObserver:self
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
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
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
        buildingMarker.map  = mapView_;
        [self.view addSubview:mapView_];
    }

}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    //Initialize core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [fetchRequest setEntity:self.buildingEntity];
    
    NSPredicate *byName = [NSPredicate predicateWithFormat:@"name == %@",marker.title];
    [fetchRequest setPredicate:byName];
    
    NSArray *object = [context executeFetchRequest:fetchRequest error:&error];
    Building *specificBuilding = object[0];
    //reposition camera
    mapView_.camera = [GMSCameraPosition cameraWithTarget:marker.position
                                                     zoom:14];
    
    self.longDescription.text = specificBuilding.longDescription;
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
