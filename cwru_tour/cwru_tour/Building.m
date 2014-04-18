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

- (Building *) setValueWithBuildingName:(NSString*) name
                              longitude:(NSString*) longitude
                               latitude:(NSString*) latitude
{
    self.name = name;
    self.longitude = [NSDecimalNumber decimalNumberWithString:longitude];
    self.latitude = [NSDecimalNumber decimalNumberWithString:latitude];
    return self;
}

@end