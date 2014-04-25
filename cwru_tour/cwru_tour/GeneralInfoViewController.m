//
//  GeneralInfoViewController.m
//  cwru_tour
//
//  Created by Sean Corcoran on 3/2/14.
//  Copyright (c) 2014 Sean Corcoran. All rights reserved.
//

#import "GeneralInfoViewController.h"

@interface GeneralInfoViewController ()

@end

@implementation GeneralInfoViewController

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
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"generalAbout" withExtension:@"html"];
    [self.generalWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
