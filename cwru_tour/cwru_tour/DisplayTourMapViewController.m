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

@interface DisplayTourMapViewController ()
    @property (strong, nonatomic) NSMutableArray *waypoints;
    @property (strong, nonatomic) NSMutableArray *waypointStrings;
    @property(strong, nonatomic) NSMutableArray *landmarksOnRoute;
@end

@implementation DisplayTourMapViewController{
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


CLLocationCoordinate2D startPoint;


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
   
    //call methods to draw route and set annotations
    [self updateCurrentLocation];
    [self createLandmarkObjects];
    
    
    [self loadRoute];
}

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
        //NSLog(@"%@ %f %f",buildingName, longitude, latitude);
        
        Landmark *temp = [[Landmark alloc] initWithTitle:buildingName waypointLatitude:waypointLatitude waypointLongitude:waypointLongitude annotationLatitude:annotationLatitude annotationLongitude:annotationLongitude];
        [self.landmarksOnRoute addObject:temp];
    }
    
//    Landmark *fijiHouse = [[Landmark alloc] initWithTitle:@"Bingham" waypointLatitude:41.502582 waypointLongitude:-81.607177 annotationLatitude:41.502582 annotationLongitude:-81.607177];
//    Landmark *wadeCommons = [[Landmark alloc] initWithTitle:@"KSL" waypointLatitude:41.506913 waypointLongitude:-81.608848 annotationLatitude: 41.506913 annotationLongitude: -81.608848];
//    Landmark *nrv = [[Landmark alloc] initWithTitle:@"Leutner Commons" waypointLatitude:41.513345 waypointLongitude:-81.605823 annotationLatitude: 41.513345 annotationLongitude:-81.605823];
//    self.landmarksOnRoute = [[NSMutableArray alloc] init];
//    [self.landmarksOnRoute addObject:nrv];
//    [self.landmarksOnRoute addObject:fijiHouse];
//    [self.landmarksOnRoute addObject:wadeCommons];
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
        landmarkMarker.map = _mapView;
        self.view = _mapView;
    }
}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    
    [infoWindow.buildingInfo setText:marker.title];
    return infoWindow;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
