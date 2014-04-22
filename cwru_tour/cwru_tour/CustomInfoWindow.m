//
//  CustomInfoWindow.m
//  cwru_tour
//
//  Created by Eric Vennaro on 4/17/14.
//  Copyright (c) 2014 Heath Hudgins. All rights reserved.
//

#import "CustomInfoWindow.h"

@implementation CustomInfoWindow

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame]; 
    if (self) {
       // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.buildingInfo action:@selector(handleTap:)];
        
        //[self.buildingInfo addGestureRecognizer:tap];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
-(void) handleTap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Tap");
    }
    NSLog(@"Tap out");
}*/

- (void)processTap:(UIGestureRecognizer *)sender{
    NSLog(@"Tap");
}


@end
