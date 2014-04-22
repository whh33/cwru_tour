//
//  DisplayTourMapViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/16/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "DisplayTourMapViewController.h"
#import "MDDirectionService.h"
#import "Landmark.h"
#import "CustomInfoWindow.h"
#import "Building.h"

@interface DisplayTourMapViewController ()
    @property (strong, nonatomic) NSMutableArray *waypoints;
    @property (strong, nonatomic) NSMutableArray *waypointStrings;
    @property(strong, nonatomic) NSMutableArray *landmarksOnRoute;
@end

@implementation DisplayTourMapViewController{
   bool firstLocationUpdate;
    CLLocationCoordinate2D startPoint;
    NSInteger landmarkCount;
    bool firstTime;
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
    //declare core data and local arrays
    self.buildingEntity = [NSEntityDescription entityForName:@"Building" inManagedObjectContext:self.managedObjectContext];
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
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

    //call methods to draw route and set annotations
    //[self updateCurrentLocation];
    [self createLandmarkObjects];
    
    
    //[self loadRoute];
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
        startPoint=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self loadRoute];
    }
}
/*
- (void)updateCurrentLocation {
    BOOL tourAlreadyRan = [[NSUserDefaults standardUserDefaults] boolForKey:@"tourAlreadyRan"];
    
    if (!tourAlreadyRan) {
        //pause to allow user to click the allow button
        sleep(2);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tourAlreadyRan"];
    }
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    sleep(1);//pause again to let the location manager time to setup
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D currentLocation = [location coordinate];
    if(!firstLocationUpdate){
        startPoint = currentLocation;
        firstLocationUpdate = YES;
    }
    [self.mapView animateToLocation:currentLocation];
}
*/

-(void) createLandmarkObjects{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [fetchRequest setEntity:self.buildingEntity];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    self.landmarksOnRoute = [[NSMutableArray alloc] init];
    
    NSString *allBuildingsInRoute = [self.instanceIndividual valueForKey:@"buildingsInRoute"];
    NSArray *record = [allBuildingsInRoute componentsSeparatedByString:@","];
    
    for (NSString *value in record) {
        NSString *buildingName = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSPredicate *byName = [NSPredicate predicateWithFormat:@"name == %@",buildingName];
        [fetchRequest setPredicate:byName];
        
        NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
        NSManagedObject *fetchedObject = array[0];
        
        double waypointLongitude = [[fetchedObject valueForKey:@"waypointLon"] doubleValue];
        double waypointLatitude = [[fetchedObject valueForKey:@"waypointLat"] doubleValue];
        double annotationLongitude= [[fetchedObject valueForKey:@"longitude"] doubleValue];
        double annotationLatitude= [[fetchedObject valueForKey:@"latitude"] doubleValue];
        
        Landmark *temp = [[Landmark alloc] initWithTitle:buildingName waypointLatitude:waypointLatitude waypointLongitude:waypointLongitude annotationLatitude:annotationLatitude annotationLongitude:annotationLongitude];
        [self.landmarksOnRoute addObject:temp];
    }

}

-(void)loadRoute{
    
    for(int i=0; i< self.landmarksOnRoute.count -1; i++){
        Landmark *temp1 = self.landmarksOnRoute[i];
        Landmark *temp2 = self.landmarksOnRoute[i+1];
        NSMutableArray *sourceDestination = [[NSMutableArray alloc] init];
        [sourceDestination addObject:temp1.getWaypointPositionString];
        [sourceDestination addObject:temp2.getWaypointPositionString];
        //if (self.waypoints.count > 1) {
            NSDictionary *query = @{ @"sensor" : @"false",
                                     @"waypoints" : sourceDestination };
            MDDirectionService *mds = [[MDDirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        //}else{
        //    NSLog(@"No route created, only %lu", (unsigned long)self.waypoints.count);
        //}
    }
    /*
    GMSMarker *startMarker = [GMSMarker markerWithPosition:startPoint];
    [self.waypoints addObject:startMarker];
    for(Landmark *landmark in self.landmarksOnRoute){
        [self.waypoints addObject:landmark.getLandmarkMarker];
    }
    NSString *startPositionString = [NSString stringWithFormat:@"%f,%f",startPoint.latitude,startPoint.longitude];
    [self.waypointStrings addObject:startPositionString];
    for(Landmark *landmark in self.landmarksOnRoute){
        [self.waypointStrings addObject:landmark.getWaypointPositionString];
    }
    if (self.waypoints.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : self.waypointStrings };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }else{
        NSLog(@"No route created, only %lu", (unsigned long)self.waypoints.count);
    }
     */
    [self addMapAnnotation];
    
}

-(void)addDirections:(NSDictionary *)json{
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = self.mapView;
}

-(void)addMapAnnotation{
    for(Landmark *landmark in self.landmarksOnRoute){
        GMSMarker *landmarkMarker = [GMSMarker markerWithPosition:[landmark.getAnnotationCoordinateObject MKCoordinateValue]];
        landmarkMarker.title = landmark.getTitle;
        landmarkMarker.map = self.mapView;
        self.view = self.mapView;
    }
}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
  
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
  //  [infoWindow initWithFrame:CGRectMake(0,0,
   //                                  infoWindow.frame.size.width,infoWindow.frame.size.height)];
   // [self.view addSubview:infoWindow];
    infoWindow.buildingInfo.backgroundColor = [UIColor clearColor];
    
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
    
    [infoWindow.buildingInfo setText: specificBuilding.longDescription];
    
    return infoWindow;
}

-(IBAction)displayAnnotation:(id)sender{
    NSInteger numLandmarks = self.landmarksOnRoute.count;
    CLLocation *userLocation = [[CLLocation alloc] init];
    userLocation = [userLocation initWithLatitude:startPoint.latitude longitude:startPoint.longitude];
    //check to make sure don't exceed the bounds of the array
    if(landmarkCount == numLandmarks){
        landmarkCount=0;
    }
    if(!firstTime){
        firstTime = YES;
        Landmark *closestLandmark;
        Landmark *firstLandmarkOnRoute = self.landmarksOnRoute[0];
        closestLandmark = firstLandmarkOnRoute;
        CLLocationDistance min = [userLocation distanceFromLocation:firstLandmarkOnRoute.getCLLocation];
        for(Landmark *currentLandmark in self.landmarksOnRoute){
            CLLocationDistance distance = [userLocation distanceFromLocation:currentLandmark.getCLLocation];
            if(distance < min){
                closestLandmark = currentLandmark;
                landmarkCount++;
                min=distance;
            }
        }
    }
    
    Landmark *currentLandmarkToAnnotate = self.landmarksOnRoute[landmarkCount];
    landmarkCount++;
    GMSMarker *testMarker = [GMSMarker markerWithPosition:[currentLandmarkToAnnotate.getAnnotationCoordinateObject MKCoordinateValue]];
    testMarker.title = currentLandmarkToAnnotate.getTitle;
    testMarker.map = (GMSMapView *)self.view;
    self.mapView.selectedMarker = testMarker;
    self.view = self.mapView;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
