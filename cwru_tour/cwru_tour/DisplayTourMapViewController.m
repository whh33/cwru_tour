//
//  DisplayTourMapViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 3/8/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "DisplayTourMapViewController.h"
#import "MDDirectionService.h"
#import "Landmark.h"
#import "CustomInfoWindow.h"
#import "Building.h"

@interface DisplayTourMapViewController () <GMSMapViewDelegate>
    @property (strong, nonatomic) NSMutableArray *waypoints;
    @property (strong, nonatomic) NSMutableArray *waypointStrings;
    @property(strong, nonatomic) NSMutableArray *landmarksOnRoute;
    @property(strong, nonatomic) NSMutableArray *annotationsOnRoute;

@end

@implementation DisplayTourMapViewController{
   bool firstLocationUpdate;
    CLLocationCoordinate2D startPoint;
    NSInteger landmarkCount;
    bool firstTime;
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //set the navigation bar title
    NSString *routeName = [self.instanceIndividual valueForKey:@"name"];
    self.navigationBar.title = routeName;
    
    //set initial web view text
    NSString *sampleText = @"<font color=\"white\"><font size=2>Press the \"Go\" button to begin the tour</font></font>";
    [self.longDescription loadHTMLString:sampleText baseURL:nil];
    
    //declare core data and local arrays
    self.buildingEntity = [NSEntityDescription entityForName:@"Building" inManagedObjectContext:self.managedObjectContext];
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
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
    
    [self createWaypointObjects];
    [self createAnnotationObjects];
    [self.view addSubview:mapView_];
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
        startPoint=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self loadRoute];
    }
}

-(void) createWaypointObjects{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [fetchRequest setEntity:self.buildingEntity];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    self.landmarksOnRoute = [[NSMutableArray alloc] init];
    
    NSString *allBuildingsInRoute = [self.instanceIndividual valueForKey:@"waypointBuildings"];
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

-(void)createAnnotationObjects{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [fetchRequest setEntity:self.buildingEntity];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    self.annotationsOnRoute = [[NSMutableArray alloc] init];
    
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
        [self.annotationsOnRoute addObject:temp];
    }
}

-(void)loadRoute{
    for(int i=0; i< self.landmarksOnRoute.count -1; i++){
        Landmark *temp1 = self.landmarksOnRoute[i];
        Landmark *temp2 = self.landmarksOnRoute[i+1];
        NSMutableArray *sourceDestination = [[NSMutableArray alloc] init];
        [sourceDestination addObject:temp1.getWaypointPositionString];
        [sourceDestination addObject:temp2.getWaypointPositionString];
        NSDictionary *query = @{ @"sensor" : @"false",
                                     @"waypoints" : sourceDestination };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
    }
}

-(void)addDirections:(NSDictionary *)json{
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
}

-(void)addMapAnnotation{
    
    for(Landmark *landmark in self.annotationsOnRoute){
        GMSMarker *landmarkMarker = [GMSMarker markerWithPosition:[landmark.getAnnotationCoordinateObject MKCoordinateValue]];
        landmarkMarker.title = landmark.getTitle;
        landmarkMarker.map = mapView_;
        [self.view addSubview:mapView_];
    }
}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    //Initialize custom info window.
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
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
                                                     zoom:mapView_.camera.zoom];
    
    NSString *descriptionHTML = @"<font color=\"white\"><font size=2>";
    descriptionHTML = [descriptionHTML stringByAppendingString:specificBuilding.longDescription];
    descriptionHTML = [descriptionHTML stringByAppendingString:@"</font></font>"];
    
    [self.longDescription loadHTMLString:descriptionHTML baseURL:nil];
    
    //[self.longDescription setContentOffset:CGPointZero animated:NO];
    //infoWindow.buildingInfo.textColor= [UIColor blueColor];
    [infoWindow.buildingInfo setText: specificBuilding.name];
    
    return infoWindow;
}

-(IBAction)displayAnnotation:(id)sender{
    NSInteger numLandmarks = self.annotationsOnRoute.count;
    CLLocation *userLocation = [[CLLocation alloc] init];
    userLocation = [userLocation initWithLatitude:startPoint.latitude longitude:startPoint.longitude];
    //check to make sure don't exceed the bounds of the array
    if(landmarkCount == numLandmarks){
        landmarkCount=0;
    }
    if(!firstTime){
        [self addMapAnnotation];
        self.nextButton.title = @"Next Sight";
        firstTime = YES;
        Landmark *closestLandmark;
        Landmark *firstLandmarkOnRoute = self.annotationsOnRoute[0];
        closestLandmark = firstLandmarkOnRoute;
        CLLocationDistance min = [userLocation distanceFromLocation:firstLandmarkOnRoute.getCLLocation];
        int position = 0;
        for(Landmark *currentLandmark in self.annotationsOnRoute){
            CLLocationDistance distance = [userLocation distanceFromLocation:currentLandmark.getCLLocation];
            if(distance < min){
                closestLandmark = currentLandmark;
                landmarkCount = position;
                min=distance;
            }
            position++;
        }
    }
    
    Landmark *currentLandmarkToAnnotate = self.annotationsOnRoute[landmarkCount];
    landmarkCount++;
    GMSMarker *testMarker = [GMSMarker markerWithPosition:[currentLandmarkToAnnotate.getAnnotationCoordinateObject MKCoordinateValue]];
    testMarker.title = currentLandmarkToAnnotate.getTitle;
    testMarker.map = mapView_;
    mapView_.selectedMarker = testMarker;
    [self.view addSubview:mapView_];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
