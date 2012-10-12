//
//  PLPLanner.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLPLanner.h"
#import "PLScanner.h"
#import "Task.h"
#import "Schedule.h"
#import "PLOfTasks.h"
#import "FreeTimeCalculator.h"
#import "AvailableTimesContainer.h"


@interface PLPLanner ()
    
-(NSArray*)getUserEventsFromDate:(NSDate*)sDate to:(NSDate*)eDate;
-(void)createPlannersTree;

@end

@implementation PLPLanner

@synthesize theGoal,theHeadPlanner;
@synthesize calendarsToScan = __calendarsToScan;

-(NSArray*)scanAndPlan
{
    NSDate *sDate = self.theGoal.schedule.startDate;
    NSDate *eDate = self.theGoal.schedule.endDate;
    

    NSArray *userEvents = [self getUserEventsFromDate:sDate to:eDate];
    AvailableTimesContainer *availableTimes = [self getFreeTimeForEvents:userEvents];

    [self createPlannersTreeWithAvailableTimes:availableTimes];
    BOOL didWePlan = [self.theHeadPlanner planTasks];
    
    NSArray *suggestedPlans = nil;
    if (didWePlan) {
        suggestedPlans = [self.theHeadPlanner getSuggestedPlans];

    }
    return suggestedPlans;
}



#pragma mark Scanning
-(NSArray*)getUserEventsFromDate:(NSDate*)sDate to:(NSDate*)eDate
{
    PLScanner *scanner = [[PLScanner alloc] initFromDate:sDate to:eDate];
    NSArray* userEvents = [scanner getEventsInCalendars:self.calendarsToScan fromDate:sDate toDate:eDate];
    return userEvents;
}

#pragma mark Create Free Time
-(AvailableTimesContainer*)getFreeTimeForEvents:(NSArray*)events
{
    
    NSDate *sDate = self.theGoal.schedule.startDate;
    NSDate *eDate = self.theGoal.schedule.endDate;
    
    FreeTimeCalculator *freeTimeCalculator = [[FreeTimeCalculator alloc] initFromDate:sDate to:eDate];
    freeTimeCalculator.userEvents = events;
    AvailableTimesContainer *availableTimes = [freeTimeCalculator calculateFreeTimeBetweenEvents];
    
    return availableTimes;
    
}

#pragma mark Planning

-(void)createPlannersTreeWithAvailableTimes:(AvailableTimesContainer*)times
{
    //we want to create a tree planners. Each planner has one that with the responsibility to plan it into the calendar
    self.theHeadPlanner = [[PLOfTasks alloc] initWithTask:self.theGoal byOwner:nil availableTimes:times];
    [self.theHeadPlanner buildStructure];
    [self.theHeadPlanner pushDownSchedule:nil];
}

#pragma mark - 
#pragma mark temp
-(NSArray*)calendarsToScan
{
    if (__calendarsToScan == nil) {
        EKEventStore *store = [[EKEventStore alloc] init];
        EKCalendar *defaultCalForScan = [store defaultCalendarForNewEvents];
        __calendarsToScan = [NSArray arrayWithObject:defaultCalForScan];
    }
    
    for (EKCalendar *cal in __calendarsToScan) {
        NSLog(@"Calendar title:::: %@",cal.title);
    }
    return __calendarsToScan;
}

@end
