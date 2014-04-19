//
//  Building.m
//  ideaTester
//
//  Created by Sean Corcoran on 3/18/14.
//  Copyright (c) 2014 EECS397. All rights reserved.
//

#import "Building.h"

@implementation Building

@dynamic name;
@dynamic longitude;
@dynamic latitude;
@dynamic waypointLon;
@dynamic waypointLat;
@dynamic description;

- (Building *) setValueWithBuildingName:(NSString*) name
                              longitude:(NSString*) longitude
                               latitude:(NSString*) latitude
                            waypointLon:(NSString *) waypointLon
                            waypointLat:(NSString *) waypointLat
                            description:(NSString *) description
{
    self.name = name;
    self.longitude = [NSDecimalNumber decimalNumberWithString:longitude];
    self.latitude = [NSDecimalNumber decimalNumberWithString:latitude];
    self.waypointLon = [NSDecimalNumber decimalNumberWithString:waypointLon];
    self.waypointLat = [NSDecimalNumber decimalNumberWithString:waypointLat];
    self.description = description;
    return self;
}

@end