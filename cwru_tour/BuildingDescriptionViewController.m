//
//  SpecificBuildingViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 3/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "BuildingDescriptionViewController.h"
#import "DirectionsViewController.h"
#import "CustomInfoWindow.h"
#import <GoogleMaps/GoogleMaps.h>

@interface BuildingDescriptionViewController () <GMSMapViewDelegate>

@end

@implementation BuildingDescriptionViewController{
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
    
    self.name.text = [self.instanceIndividual valueForKey:@"name"];
    self.name.numberOfLines = 4;
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:19]];
    [self.name sizeToFit];
    
    NSString *descriptionHTML = @"<font color=\"white\"><font size=2>";
    NSString *dataString = [self.instanceIndividual valueForKey:@"longDescription"];
    descriptionHTML = [descriptionHTML stringByAppendingString:dataString];
    descriptionHTML = [descriptionHTML stringByAppendingString:@"</font></font>"];
    
    [self.description loadHTMLString:descriptionHTML baseURL:nil];
    
    //initialize map as a section of the view controller
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height / 3;
    frame.origin.y= frame.size.height - 50;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[self.instanceIndividual valueForKey:@"Latitude"] doubleValue]
                                                            longitude:[[self.instanceIndividual valueForKey:@"Longitude"] doubleValue]
                                                                 zoom:17];
    
    mapView_ = [GMSMapView mapWithFrame:frame camera:camera];
    mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.delegate = self;
    
    //add the annotation
    CLLocationCoordinate2D buildingLocation =CLLocationCoordinate2DMake([[self.instanceIndividual valueForKey:@"Latitude"] doubleValue], [[self.instanceIndividual valueForKey:@"Longitude"] doubleValue]);
    GMSMarker *buildingMarker = [GMSMarker markerWithPosition:buildingLocation];
    buildingMarker.title = [self.instanceIndividual valueForKey:@"name"];
    buildingMarker.map = mapView_;
    
    [self.view addSubview:mapView_];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    //Initialize custom info window.
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];

    //reposition camera
    mapView_.camera = [GMSCameraPosition cameraWithTarget:marker.position
                                                     zoom:mapView_.camera.zoom];
    
    //infoWindow.buildingInfo.textColor= [UIColor blueColor];
    [infoWindow.buildingInfo setText: marker.title];
    
    return infoWindow;
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