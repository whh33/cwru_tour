//
//  Landmark.m
//  googleMaps
//
//  Created by Eric Vennaro on 3/23/14.
//  Copyright (c) 2014 Eric Vennaro. All rights reserved.
//

#import "Landmark.h"
@implementation Landmark
@synthesize title, landmarkMarker, landmarkPositionString, coordinate, annotationCoordinate;

-(id) initWithTitle: (NSString *) landmarkTitle waypointLatitude: (double) wLat waypointLongitude: (double) wLon annotationLatitude: (double) aLat annotationLongitude: (double) aLon{
    self = [super init];
    if(self){
        title = landmarkTitle;
        [self setCLLocatinCoordinateObject:wLat with:wLon];
        [self setLandmarkMarker];
        [self setAnnotationCLLocationCoordinate: (double)aLat with: (double)aLon];
        [self setWaypointPositionString:(double) wLat and:(double) wLon];
        
    }
    return self;
}

-(void) setLandmarkMarker{
    landmarkMarker = [GMSMarker markerWithPosition:[coordinate MKCoordinateValue]];
}
-(void) setCLLocatinCoordinateObject:(double)latitude with:(double)longitude{
    CLLocationCoordinate2D newCoord = CLLocationCoordinate2DMake(latitude, longitude);
    coordinate = [NSValue valueWithMKCoordinate:newCoord];
}
-(void) setWaypointPositionString:(double)latitude and: (double) longitude{
    landmarkPositionString = [NSString stringWithFormat:@"%f, %f", latitude,longitude];
}
-(void) setAnnotationCLLocationCoordinate: (double)latitude with:(double)longitude{
    CLLocationCoordinate2D newCoord = CLLocationCoordinate2DMake(latitude, longitude);
    annotationCoordinate = [NSValue valueWithMKCoordinate:newCoord];
}
-(id) getTitle{
    return title;
}

-(id) getLandmarkMarker{
    return landmarkMarker;
}

-(id) getcoordinateObject{
    return coordinate;
}

-(id) getWaypointPositionString{
    return landmarkPositionString;
}

-(id) getAnnotationCoordinateObject{
    return annotationCoordinate;
}

@end
