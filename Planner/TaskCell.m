//
//  TaskCell.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()
-(void)setUpSwipes;
-(void)swipeRight:(id)sender;
-(void)swipeLeft:(id)sender;
@end

@implementation TaskCell

@synthesize titleLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSwipes];
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark Handle Swipes

-(void)setUpSwipes
{
    UISwipeGestureRecognizer* gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:gestureR];
    
    UISwipeGestureRecognizer *gestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    gestureL.direction = UISwipeGestureRecognizerDirectionLeft; // default
    [self addGestureRecognizer:gestureL];
}
-(void)swipeRight:(id)sender
{
    NSLog(@"RIGHT RIGHT");
    
}

-(void)swipeLeft:(id)sender
{
    NSLog(@"LEFT LEFT");
    
}

@end
