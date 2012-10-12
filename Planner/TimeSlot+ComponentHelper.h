//
//  TimeSlot+ComponentHelper.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeSlot.h"
#import "PLAvailableTimeSlot.h"

typedef enum {
    DayMon = 2,
    DayTue,
    DayWed,
    DayThu,
    DayFri,
    DaySat,
    DaySun = 1
} ComponentsDay;

@interface TimeSlot (ComponentHelper)

-(BOOL)doesSlotFitBetween:(NSDateComponents*)startComp and:(NSDateComponents*)endComp;

@end
