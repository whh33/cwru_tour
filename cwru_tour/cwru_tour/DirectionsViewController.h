//
//  DirectionsViewController.h
//  cwru_tour
//
//  Created by Eric Vennaro on 4/2/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DirectionsViewController : UIViewController<GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSMutableString * title;
@end
