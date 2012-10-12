//
//  FreeTimeCalculator.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreeTimeCalculator.h"
#import "PLAvailableTimeSlot.h"
#import "AvailableTimesContainer.h"
#import "NSDate+Compare.h"


@implementation FreeTimeCalculator

@synthesize userEvents;
@synthesize startDate = __startDate;
@synthesize endDate = __endDate;
@synthesize shouldCutAtMidnight;

@synthesize currentCal;

-(id)initFromDate:(NSDate *)sDate to:(NSDate *)eDate
{
    self = [super init];
    if (self) {
        self.startDate = sDate;
        self.endDate = eDate;
        self.shouldCutAtMidnight = NO;
        self.currentCal = [NSCalendar currentCalendar];
        _timeSlots = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(AvailableTimesContainer*)calculateFreeTimeBetweenEvents
{
    //pointers for loop
    NSDate *startDate = self.startDate;
    NSDate *endDate;
    
    //set the beginning of each free time to the previous event endDate
    //and the end of each free time to the next start.date
    for (EKEvent *event in self.userEvents) {
        
        if ([startDate isEarlierThanOrEqualTo:event.startDate]) {
            //if they are back to back, or the event is starting earlier than the last one ended
            //there's no free time in between. Skip
            continue;
        } else {
            endDate = event.endDate;
            [self insertTimeSlotsForLotsOfDaysBetweenStartDate:startDate to:endDate];
        }
        startDate = event.endDate;
        
    }
    //corner case, and if user event is empty.
    endDate = self.endDate;
    [self insertTimeSlotsForLotsOfDaysBetweenStartDate:startDate to:endDate];
    
    AvailableTimesContainer *container = [[AvailableTimesContainer alloc] initWithAvailableTimes:_timeSlots];
    
    return container;
}

-(void)insertTimeSlotsForLotsOfDaysBetweenStartDate:(NSDate*)startDate to:(NSDate*)endDate
{
    NSDate *dateForMidnight;
    //constants for loop
    NSUInteger lengthOfADay = 60*60*24;
    
    
    while ([self areDatesDifferentDays:startDate andDate:endDate])
    {
        dateForMidnight = [startDate dateByAddingTimeInterval:lengthOfADay];
        //set dateForMidnight to the beginning of the day
        [self.currentCal rangeOfUnit:NSDayCalendarUnit
                           startDate:&dateForMidnight
                            interval:NULL
                             forDate:dateForMidnight];
        [self insertNewPLAVTSLotIntoArrayWithStartDate:startDate to:dateForMidnight];
        startDate = dateForMidnight;
        
    }
    //last loop for when they are on the same day.
    if (![startDate isEqualToDate:endDate]) {
        [self insertNewPLAVTSLotIntoArrayWithStartDate:startDate to:endDate];
    }
}

-(BOOL)areDatesDifferentDays:(NSDate*)date1 andDate:(NSDate*)date2
{
    
    int weekDay1 = [self.currentCal ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date1];
    int week1 = [self.currentCal ordinalityOfUnit:NSWeekCalendarUnit inUnit:NSEraCalendarUnit forDate:date1];  

    int weekDay2 = [self.currentCal  ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date2];
    int week2 = [self.currentCal ordinalityOfUnit:NSWeekCalendarUnit inUnit:NSEraCalendarUnit forDate:date1];  
    
    BOOL areDifferent = (weekDay1 == weekDay2 && week1 == week2)  ? NO : YES;
    return areDifferent;
}

#pragma mark Data Creation
-(void)insertNewPLAVTSLotIntoArrayWithStartDate:(NSDate*)sDate to:(NSDate*)eDate
{
    PLAvailableTimeSlot *timeSlot = [[PLAvailableTimeSlot alloc] initFromDate:sDate to:eDate];
    [_timeSlots addObject:timeSlot];
    
}


@end
