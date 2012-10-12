//
//  Schedule+helper.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Schedule+helper.h"

@implementation Schedule (helper)

- (void)addTimeslot:(TimeSlot *)value
{
    NSMutableOrderedSet* tempSet = [self mutableOrderedSetValueForKey:@"timeslots"];
    [tempSet addObject:value];
}

@end
