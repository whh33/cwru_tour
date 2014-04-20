//
//  SpecificBuildingViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "BuildingDescriptionViewController.h"
#import "DirectionsViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface BuildingDescriptionViewController () <GMSMapViewDelegate>

@end

@implementation BuildingDescriptionViewController{
    GMSMapView *mapView_;
    GMSMapView *boundMapView_;
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
    
    self.name.text = [self.instanceIndividual valueForKey:@"name"];
    self.name.numberOfLines = 4;
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:19]];
    [self.name sizeToFit];
    
    self.description.text = [self.instanceIndividual valueForKey:@"longDescription"];
    //initialize map as a section of the view controller
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height / 3;
    frame.origin.y= frame.size.height - 50;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[self.instanceIndividual
                                                                        valueForKey:@"Latitude"] doubleValue]
                                                            longitude:[[self.instanceIndividual valueForKey:@"Longitude"] doubleValue]
                                                                 zoom:17];
    
    mapView_ = [GMSMapView mapWithFrame:frame camera:camera];
    mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.delegate = self;
    //add annotation
    CLLocationCoordinate2D buildingLocation =CLLocationCoordinate2DMake([[self.instanceIndividual valueForKey:@"Latitude"] doubleValue], [[self.instanceIndividual valueForKey:@"Longitude"] doubleValue]);
    GMSMarker *buildingMarker = [GMSMarker markerWithPosition:buildingLocation];
    buildingMarker.title = [self.instanceIndividual valueForKey:@"name"];
    buildingMarker.map = mapView_;
    
    [self.view addSubview:mapView_];
}

//+ (GMSCameraPosition *)defaultCamera{
//    
//    return [GMSCameraPosition cameraWithLatitude:37.7847
//                                       longitude:-122.41
//                                            zoom:5];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"directions"]) {
        DirectionsViewController *directionsViewController = [segue destinationViewController];
        
        directionsViewController.latitude = [self.instanceIndividual valueForKey:@"Latitude"];
        directionsViewController.longitude= [self.instanceIndividual valueForKey:@"Longitude"];
        directionsViewController.title = [self.instanceIndividual valueForKey:@"name"];
    }
}


@end