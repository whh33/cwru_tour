//
//  SpecificBuildingViewController.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/18/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "BuildingDescriptionViewController.h"
#import "DirectionsViewController.h"

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
    self.name.numberOfLines = 4;
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:19]];
    [self.name sizeToFit];
    
    self.description.text = [self.instanceIndividual valueForKey:@"longDescription"];
   
    
    //[self.view addSubview:myView];
    
    /*
    id temp = [self.instanceIndividual valueForKey:@"longitude"];
    self.longitude.text = [temp stringValue];
    
    temp = [self.instanceIndividual valueForKey:@"latitude"];
    self.latitude.text = [temp stringValue];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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