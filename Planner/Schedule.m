//
//  Schedule.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Schedule.h"
#import "Task.h"
#import "TimeSlot.h"


@implementation Schedule

@dynamic endDate;
@dynamic eventPadding;
@dynamic maxEventTime;
@dynamic maxNoOfEventsPerDay;
@dynamic maxNoOfEventsPerWeek;
@dynamic minEventTime;
@dynamic reminderBeforeEventStart;
@dynamic scheduleOnWeekdays;
@dynamic scheduleOnWeekends;
@dynamic startDate;
@dynamic ownerSchedule;
@dynamic timeslots;

@end
