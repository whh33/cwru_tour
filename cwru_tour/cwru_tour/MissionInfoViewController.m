//
//  MissionInfoViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 4/16/14.
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
    NSString *info = @"\tThe Case Western Reserve University Office of Undergraduate Admissions currently offers in-person, campus tours to any prospective student and their family. These tours are offered at set times during the week. In order to provide more consistent access to campus tours, this was created to provide self-guided tours to the University’s visitors, helping to provide them with a better on-campus experience.\n\n\tThis product provides ancillary services to compliment the self-guided tour. It currently functions in two different modes. The user can either walk around campus on their own, and have the application give them information about relevant university destinations or the user can go on a predetermined tour route. The length and destination of the tour can be changed based on what the visitor is interested. The app will also be able to schedule tours and interviews directly with the Office of Undergraduate Admissions.";
    [self.missionTextView setText:info];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
