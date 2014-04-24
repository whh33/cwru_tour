//
//  MissionInfoViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 3/16/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "MissionInfoViewController.h"

@interface MissionInfoViewController ()

@end

@implementation MissionInfoViewController

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
    //[self.missionTextView setText:info];
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"missionInfo" withExtension:@"html"];
    [self.missionWebView loadRequest:[NSURLRequest requestWithURL:url]];    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
