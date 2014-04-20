//
//  DirectionsViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/20/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "DirectionsViewController.h"
#import "MDDirectionService.h"

@interface DirectionsViewController ()

@end

@implementation DirectionsViewController{
      BOOL firstLocationUpdate_;
    CLLocation *location;
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
    //start map setup
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.latitude doubleValue]
                                                            longitude:[self.longitude doubleValue]
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
    CLLocationCoordinate2D buildingLocation =CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    GMSMarker *buildingMarker = [GMSMarker markerWithPosition:buildingLocation];
    buildingMarker.title = self.title;
    buildingMarker.map = _mapView;
    self.view = _mapView;
    
    // Listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = _mapView;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
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
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        location = [change objectForKey:NSKeyValueChangeNewKey];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:14];
            [self loadRoute];
    }
}

-(void)loadRoute{
    
    NSMutableArray *sourceDestination = [[NSMutableArray alloc] init];
    NSString *source = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude ,location.coordinate.longitude];
    NSString *destination = [NSString stringWithFormat:@"%f, %f", [self.latitude doubleValue],[self.longitude doubleValue]];
    [sourceDestination addObject:source];
    [sourceDestination addObject:destination];
    NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : sourceDestination };
    MDDirectionService *mds = [[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
                withSelector:selector
                withDelegate:self];
}

-(void)addDirections:(NSDictionary *)json{
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = self.mapView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
