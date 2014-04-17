//
//  DisplayTourMapViewController.h
//  cwru_tour
//
//  Created by Eric Vennaro on 4/16/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface DisplayTourMapViewController : UIViewController <GMSMapViewDelegate>
    @property (strong, nonatomic) GMSMapView *mapView;


@end
