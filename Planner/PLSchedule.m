//
//  PLSchedule.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLSchedule.h"

@implementation PLSchedule

@synthesize endDate;
@synthesize eventPadding;
@synthesize maxEventTime;
@synthesize maxNoOfEventsPerDay;
@synthesize maxNoOfEventsPerWeek;
@synthesize minEventTime;
@synthesize reminderBeforeEventStart;
@synthesize scheduleOnWeekdays;
@synthesize scheduleOnWeekends;
@synthesize startDate;
@synthesize timeslots;

@synthesize timeLeft;

-(NSUInteger)getPaddingInSeconds
{
    NSUInteger padding = [self.eventPadding intValue];
    padding *= 60;
    return padding;
}

@end
