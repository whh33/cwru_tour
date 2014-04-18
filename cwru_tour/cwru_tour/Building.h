//
//  Building.h
//  ideaTester
//
//  Created by Sean Corcoran on 3/18/14.
//  Copyright (c) 2014 EECS397. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Building : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@end

@interface Building (CoreDataGeneratedAccessors)

- (Building *) setValueWithBuildingName:(NSString*) name
                              longitude:(NSString*) longitude
                               latitude:(NSString*) latitude;

@end