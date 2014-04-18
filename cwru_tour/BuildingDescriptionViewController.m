//
//  SpecificBuildingViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "BuildingDescriptionViewController.h"

@interface BuildingDescriptionViewController ()

@end

@implementation BuildingDescriptionViewController

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
    
    id temp = [self.instanceIndividual valueForKey:@"longitude"];
    self.longitude.text = [temp stringValue];
    
    temp = [self.instanceIndividual valueForKey:@"latitude"];
    self.latitude.text = [temp stringValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end