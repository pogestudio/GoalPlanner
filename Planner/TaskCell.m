//
//  TaskCell.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define INDENTATION_WIDTH 20

#import "Task+helper.h"
#import "TaskCell.h"
#import "TaskHandler.h"


@interface TaskCell()
-(void)setUpSwipes;
-(void)swipeRight:(id)sender;
-(void)swipeLeft:(id)sender;
-(void)getCurrentIndentation;
@end

@implementation TaskCell

@synthesize titleLabel,subLabel;
@synthesize taskForCell;
@synthesize tableIndentation;
@synthesize taskHandler;
@synthesize taskDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSwipes];
        if (!self.indentationWidth) {
            self.indentationWidth = INDENTATION_WIDTH;
        }
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Layout

-(void)setUpcellWithTask:(Task*)task andParentTask:(Task *)parentTask
{
    self.titleLabel.text = task.title;
    self.subLabel.text = task.taskDescription;
    self.taskForCell = task;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self indentToRightLevelsWithAnimation:NO];
    
}

-(void)indentToRightLevelsWithAnimation:(BOOL)animation
{
    [self getCurrentIndentation];
    
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    //NSLog(@"CELL:%@, Indentation :%d SortKey:%d",self.titleLabel.text,self.indentationLevel,[self.taskForCell.sortKey intValue]);
    //NSLog(@"X:%.f Y:%.f W:%.f H:%.f",self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.size.width,self.contentView.frame.size.height);
    
    CGRect newFrame = CGRectMake(indentPoints,
                                 self.contentView.frame.origin.y,
                                 self.contentView.frame.size.width - indentPoints, 
                                 self.contentView.frame.size.height);
    
    if (animation) {
        [UIView
         animateWithDuration:0.5
         animations:^{
             self.contentView.frame = newFrame;
         }];
    }
    else {
        self.contentView.frame = newFrame;
    }
    
}

-(void)getCurrentIndentation
{
    Task* parentTask = self.taskHandler.theHeadTask;
    self.indentationLevel = [self.taskForCell indentationUntil:parentTask];
}

#pragma mark -
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
    BOOL succeeded = [self.taskHandler tryToIncreaseDepthOfTask:self.taskForCell];
                   
    if (succeeded) {
        //we neeed to update the children as well
        [self.taskDelegate layoutSubviewsForAllVisibleCellsInTableviewWithAnimation:YES];
    }
    
}

-(void)swipeLeft:(id)sender
{
    NSLog(@"LEFT LEFT");
    
    BOOL succeeded = [self.taskHandler tryToDecreaseDepthOfTask:self.taskForCell];
    
    if (succeeded) {
        //we neeed to update the children as well
        [self.taskDelegate layoutSubviewsForAllVisibleCellsInTableviewWithAnimation:YES];
    }
    
}

@end
