//
//  TimeSlot+ComponentHelper.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeSlot+ComponentHelper.h"
#import "NSDateComponents+Compare.h"

@implementation TimeSlot (ComponentHelper)

-(BOOL)doesSlotFitBetween:(NSDateComponents *)startComp and:(NSDateComponents *)endComp
{
    //DEBUG PURPOSES
    
    
    [startComp printInfoAfterString:@"startcomp"];
    [endComp printInfoAfterString:@"endcomp"];
    
    
    [self.startTime printInfoAfterString:@"Slot starts at"];
    [self.endTime printInfoAfterString:@"slot ends at"];
    
    NSDateComponents *slotStart = self.startTime;
    NSDateComponents *slotEnd = self.endTime;
    
    BOOL slotFits = [startComp isEarlierInWeekThan:slotEnd] &&
    [slotStart isEarlierInWeekThan:endComp];
    BOOL sameDay = [startComp weekday] == [slotStart weekday];
    
    BOOL doesFit = slotFits && sameDay;
    return doesFit;
}
@end
