//
//  SignUpViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 2/28/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "AboutInfoViewController.h"

@interface AboutInfoViewController ()

@end

@implementation AboutInfoViewController

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
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


@end
