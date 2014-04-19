//
//  Route.h
//  cwru_tour
//
//  Created by Eric Vennaro on 4/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * buildingsInRoute;
@end

@interface Route (CoreDataGeneratedAccessors)

@end
