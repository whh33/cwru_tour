//
//  GeneralInfoViewController.m
//  cwru_tour
//
//  Created by Heath Hudgins on 4/16/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
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
    //[super viewWillAppear:animated];
    NSString *aboutInfo = @"\tCase Western Reserve was originally founded in 1826, and our history is as long and storied as our name. What began as two separate institutions — Case Institute of Technology and Western Reserve College — federated in 1967 to form Case Western Reserve University, which immediately became one of the country's leading research institutions.\n\n\tWith an endowment of more than $1.4 billion, Case Western Reserve supports about 100 designated academic and research centers, and receives nearly $400 million in external research awards each year. Our eight schools and college offer close to 200 top-ranked undergraduate, graduate and professional programs that range from arts, law and humanities to engineering and medicine.\n\n\tVirtually all 2,600+ faculty members hold doctorate or appropriate terminal degrees. They are researchers. They are teachers. They are leaders in their fields. In fact, Case Western Reserve counts 15 Nobel laureates (including the first American scientist to receive the prize) among our current and former faculty and alumni.\n\n\t About 10,000 students — 40 percent undergraduate — are enrolled at the university, representing all 50 states and more than 100 countries. But our students are more than just numbers. Case Western Reserve students are the best and the brightest in the nation, featuring Fulbright, Goldwater and National Science Foundation scholars (to name a few) who seek challenges within and beyond the classroom.\n\n\t Outside those state-of-the-art classrooms, our unique urban campus bustles across 155 acres in University Circle, a vibrant cultural district just five miles east of downtown Cleveland, Ohio. A cornerstone institution, Case Western Reserve generates a $1 billion impact on the region's economy with innovative technologies, social services and cutting-edge research.";
    [self.generalTextView setText:aboutInfo];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
 -(void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 [self.navigationController setNavigationBarHidden:NO];
 }
 */

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
