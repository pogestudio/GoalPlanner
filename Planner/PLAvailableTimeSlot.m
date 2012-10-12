//
//  PLAvailableTimeSlot.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLAvailableTimeSlot.h"

#import "PLSchedule.h"
#import "TimeSlot+ComponentHelper.h"
#import "NSDateComponents+Compare.h"

@interface PLAvailableTimeSlot()
@end

@implementation PLAvailableTimeSlot

@synthesize startTime;
@synthesize endTime;
@synthesize isScheduled = __isScheduled;
@synthesize tempSchedule;
@synthesize delegate;

-(id)initFromDate:(NSDate *)sDate to:(NSDate *)eDate
{
    self = [super init];
    if (self) {
        self.startTime = sDate;
        self.endTime = eDate;
        self.isScheduled = NO;
    }
    
    return self;
}

-(BOOL)moldSlotToFitSchedule:(PLSchedule *)schedule
{
    self.tempSchedule = schedule;
    
    NSUInteger duration = [self.endTime timeIntervalSinceDate:self.startTime];
    NSUInteger padding = [self.tempSchedule getPaddingInSeconds];
    duration = duration - padding * 2;
    duration = duration /(60.0); //Get in minutes

    NSDictionary *prefStartAndEnd = [self preferableStartAndEndTimes];
    
    BOOL ATIsLongerThanMin = duration >= [schedule.minEventTime floatValue];
    BOOL ATFitTimeSlots = prefStartAndEnd != nil ? YES : NO;
    BOOL ShouldWeScheduleOnThisDay = [self shouldWeScheduleOnThisDay];
    
    if (!ATIsLongerThanMin ||
        !ATFitTimeSlots ||
        !ShouldWeScheduleOnThisDay) {
        return NO;
    }
    
    //OK! we can do this. Save old dates
    NSDate *oldStart = [self.startTime copy];
    NSDate *oldEnd = [self.endTime copy];
    [self  moldSlotWithPrefTimes:prefStartAndEnd];
    
    [self seeIfWeShouldCreateNewSlotsWithOldStartDate:oldStart andOldEndDate:oldEnd];
    //now we hould schedule current slot
    return YES;
}
     
-(void)moldSlotWithPrefTimes:(NSDictionary*)times
{
    //zero the values, then add the seconds from date components.
    NSDateComponents *startComp = [times objectForKey:@"startTime"];
    NSDateComponents *endComp = [times objectForKey:@"endTime"];
    NSCalendar *cal = [self.delegate defaultCalendar];
    
    NSDate *startDate = self.startTime;
    [cal rangeOfUnit:NSDayCalendarUnit
                       startDate:&startDate
                        interval:NULL
                         forDate:startDate];
    
    NSDate *endDate = self.endTime;
    [cal rangeOfUnit:NSDayCalendarUnit
           startDate:&endDate
            interval:NULL
             forDate:endDate];
    
    NSUInteger secondsForStartComp = [startComp secondsInThisDay];
    NSUInteger secondsForEndComp = [endComp secondsInThisDay];
    self.startTime = [startDate dateByAddingTimeInterval:secondsForStartComp];
    self.endTime = [startDate dateByAddingTimeInterval:secondsForEndComp];


}


#pragma mark Date and Scheduling logic
-(NSDictionary*)preferableStartAndEndTimes
{
    NSCalendar *calendar = [self.delegate defaultCalendar];
    unsigned dayHourMinutesFlag = NSHourCalendarUnit | NSMinuteCalendarUnit |  NSWeekdayCalendarUnit;
    NSDateComponents *startComp = [calendar components:dayHourMinutesFlag fromDate:self.startTime];
    NSDateComponents *endComp = [calendar components:dayHourMinutesFlag fromDate:self.endTime];
    
    //DEBUG PURPOSES
    //[startComp printInfoAfterString:@"startComp"];
    //[endComp printInfoAfterString:@"endComp"];
    
    NSDateComponents *slotStart;
    NSDateComponents *slotEnd;
    
    NSDateComponents *startToUse; 
    NSDateComponents *endToUse;

    BOOL doesItFit = NO;
    for (TimeSlot* slot in self.tempSchedule.timeslots) {
        slotStart = slot.startTime;
        slotEnd = slot.endTime;
        
        BOOL slotFits = [slot doesSlotFitBetween:startComp and:endComp];
        if (!slotFits) {
            continue;
        }
        
        startToUse = [startComp getLatest:slotStart];
        endToUse = [endComp getEarliest:slotEnd];
        
        CGFloat maxEventTime =  [self.tempSchedule.maxEventTime intValue] / 60.0;
        CGFloat maxDuration = MIN(maxEventTime, self.tempSchedule.timeLeft);
        
        [endToUse modifyToNotBeLongerFrom:startToUse than:maxDuration];
        
        //DEBUG PURPOSES
        //[startToUse printInfoAfterString:@"prefStart"];
        //[endToUse printInfoAfterString:@"prefEnd"];
        
        NSInteger duration = [startToUse secondsUntil:endToUse] / 60.0; //get minutes
        NSInteger timeLeftLowerBound = self.tempSchedule.timeLeft *  60 * 0.9;
        NSInteger timeLeftUpperBound = self.tempSchedule.timeLeft *  60 * 1.1;
        BOOL durationIsSimilarToTimeLeft = duration >= timeLeftLowerBound && duration <= timeLeftUpperBound;
        
        if (duration > [self.tempSchedule.minEventTime intValue] || 
            durationIsSimilarToTimeLeft) {
            doesItFit = YES;
            break;
        }
    }
    
    NSDictionary *returnDict = nil;
    if (doesItFit) {
        returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:startToUse, @"startTime",endToUse,@"endTime", nil];
    }
    return returnDict;
}

-(BOOL)shouldWeScheduleOnThisDay
{
    NSCalendar *calendar = [self.delegate defaultCalendar];
    ComponentsDay dayOfWeek = [[calendar components:(NSWeekdayCalendarUnit) fromDate:self.startTime] weekday];

    BOOL itsWeekend = dayOfWeek == DaySat || dayOfWeek == DaySun;
    
    BOOL wantWeekend = [self.tempSchedule.scheduleOnWeekends boolValue];
    BOOL wantWeekday = [self.tempSchedule.scheduleOnWeekdays boolValue];
    
    BOOL wantToSchedule = NO;
    if ((itsWeekend && wantWeekend)
        || (!itsWeekend && wantWeekday)) {
        wantToSchedule = YES;
    }
    return wantToSchedule;
}
         
#pragma mark -
#pragma mark Available Slot Creation


-(void)seeIfWeShouldCreateNewSlotsWithOldStartDate:(NSDate*)oldStartDate andOldEndDate:(NSDate*)oldEndDate
{
    if (![oldStartDate isEqualToDate:self.startTime]) {
        [self insertSlotBeforeNewDateFrom:oldStartDate withPadding:YES];
    }
    
    if (![oldEndDate isEqualToDate:self.endTime]) {
        [self insertSlotAfterNewDateTo:oldEndDate withPadding:YES];
    }    
}

-(void)insertSlotBeforeNewDateFrom:(NSDate*)oldStart withPadding:(BOOL)shouldUsePadding
{
    NSInteger padding = [self.tempSchedule getPaddingInSeconds];
    NSDate *endForNewSlot;
    if (shouldUsePadding) {
        endForNewSlot = [self.startTime dateByAddingTimeInterval: - padding]; //negate to remove.
    } else {
        endForNewSlot = [self.startTime copy];
    }
    
    [self.delegate createNewTimeSlotFromDate:oldStart to:endForNewSlot atPositionOf:InsertAtPositionBefore of:self];
}
 
-(void)insertSlotAfterNewDateTo:(NSDate*)oldEnd withPadding:(BOOL)shouldUsePadding
{
    NSUInteger padding = [self.tempSchedule getPaddingInSeconds];
    NSDate *startForNewSlot;
    if (shouldUsePadding) {
        startForNewSlot = [self.endTime dateByAddingTimeInterval: + padding]; //negate to remove.
    } else {
        startForNewSlot = [self.endTime copy];
    }
    
    [self.delegate createNewTimeSlotFromDate:startForNewSlot to:oldEnd atPositionOf:InsertAtPositionAfter of:self];
    
}


@end
