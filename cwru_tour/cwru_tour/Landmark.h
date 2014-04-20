//
//  Landmark.h
//  googleMaps
//
//  Created by Eric Vennaro on 3/23/14.
//  Copyright (c) 2014 Eric Vennaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface Landmark : NSObject <GMSMapViewDelegate>{
    NSString *title;
    GMSMarker *landmarkMarker;
    NSString *landmarkPositionString;
    NSValue *coordinate;
}

@property(nonatomic, readwrite) NSString *title;
@property(nonatomic, copy) GMSMarker *landmarkMarker;
@property(nonatomic, readwrite) NSString *landmarkPositionString;
@property(nonatomic, readwrite) NSValue *coordinate;
@property(nonatomic, readwrite) NSValue *annotationCoordinate;
@property(nonatomic, readwrite)CLLocation *landmarkLocation;
-(id) initWithTitle: (NSString *) landmarkTitle waypointLatitude: (double) wLat waypointLongitude: (double) wLon annotationLatitude: (double) aLat annotationLongitude: (double) aLon;
-(void) setLandmarkMarker;
-(void) setCLLocatinCoordinateObject:(double)latitude with:(double)longitude;
-(void) setWaypointPositionString:(double)latitude and: (double) longitude;
-(void) setAnnotationCLLocationCoordinate: (double)latitude with:(double)longitude;
-(void) setCLLocation:(double)latitude with:(double)longitude;
-(id) getWaypointPositionString;
-(id) getLandmarkMarker;
-(id) getcoordinateObject;
-(id) getTitle;
-(id) getAnnotationCoordinateObject;
-(id)getCLLocation;

@end