//
//  PLEvent.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLEvent.h"

@implementation PLEvent

@synthesize plannedTask;
@synthesize startTime, endTime;
@synthesize planningSchedule;

-(id)initForTask:(Task *)task schedule:(PLSchedule *)schedule from:(NSDate *)sDate to:(NSDate *)eDate
{
    self = [super init];
    if (self)
    {
        self.plannedTask = task;
        self.planningSchedule = schedule;
        self.startTime = sDate;
        self.endTime = eDate;
    }
    
    return self;
}

@end
