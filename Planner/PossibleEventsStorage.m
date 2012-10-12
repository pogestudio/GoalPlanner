//
//  PossibleEventsStorage.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "PossibleEventsStorage.h"
#import "Task.h"
#import "PLSchedule.h"
#import "PLEvent.h"

@implementation PossibleEventsStorage

@synthesize suggestedEvents;

-(id)init
{
    self = [super init];
    if (self) {
        self.suggestedEvents = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)addEventForTask:(Task *)task schedule:(PLSchedule *)schedule from:(NSDate *)sDate to:(NSDate *)eDate
{
    PLEvent *event = [[PLEvent alloc] initForTask:task schedule:schedule from:sDate to:eDate];
    [self.suggestedEvents addObject:event];
    
}

@end
