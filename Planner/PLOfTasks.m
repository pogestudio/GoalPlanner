//
//  PLOfTasks.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLOfTasks.h"
#import "Task.h"
#import "Schedule.h"
#import "PLAvailableTimeSlot.h"
#import "AvailableTimesContainer.h"
#import "PLSchedule.h"
#import "PossibleEventsStorage.h"

@interface PLOfTasks ()
-(void)copyTaskScheduleToSelf:(Schedule*)schedule;
-(void)insertValuesFromParentSchedule:(PLSchedule*)schedule;
-(BOOL)planThisTask;

@end

@implementation PLOfTasks

@synthesize timeLeftToPlan, taskToPlan, scheduleForTask, subPlanners, endTime;
@synthesize availableTimes;
@synthesize suggestedEvents = __suggestedEvents;

-(id)initWithTask:(Task *)task byOwner:(PLOfTasks *)ownerOrNil availableTimes:(AvailableTimesContainer *)times;
{
    self = [super init];
    if (self) {
        if (ownerOrNil != nil) {
            _ownerPlanner = ownerOrNil;
        }
        self.availableTimes = times;
        self.taskToPlan = task;
        self.timeLeftToPlan = [task.duration floatValue];
        self.scheduleForTask = [[PLSchedule alloc] init];
    }
    
    return self;
}

#pragma mark Data Structure Building
-(void)buildStructure
{
    //if task does not have subtasks, we cannot build anything.
    if (![self.taskToPlan.hasSubtasks boolValue]) {
        return;
    }
    self.subPlanners = [[NSMutableArray alloc] initWithCapacity:[self.taskToPlan.subTasks count]];
    
    PLOfTasks *childPlanner; 
    for (Task* subtask in self.taskToPlan.subTasks) {
        childPlanner = [[PLOfTasks alloc] initWithTask:subtask
                                               byOwner:self
                                        availableTimes:self.availableTimes];
        childPlanner.suggestedEvents = self.suggestedEvents;
        [childPlanner buildStructure];
        [self.subPlanners addObject:childPlanner];
    }
}

#pragma mark -
#pragma mark Schedule
-(void)pushDownSchedule:(PLSchedule *)scheduleOrNil
{
    [self copyTaskScheduleToSelf:self.taskToPlan.schedule];
    [self insertValuesFromParentSchedule:scheduleOrNil];
    
    for (PLOfTasks* subPlanner in self.subPlanners) {
        //Push down the new version of the schedule, with filled in values
        [subPlanner pushDownSchedule:self.scheduleForTask];
    }
}

-(void)copyTaskScheduleToSelf:(Schedule *)schedule
{
    self.scheduleForTask.endDate = schedule.endDate;
    self.scheduleForTask.eventPadding = schedule.eventPadding;
    self.scheduleForTask.maxEventTime = schedule.maxEventTime;
    self.scheduleForTask.maxNoOfEventsPerDay = schedule.maxNoOfEventsPerDay;
    self.scheduleForTask.maxNoOfEventsPerWeek = schedule.maxNoOfEventsPerWeek;
    self.scheduleForTask.minEventTime = schedule.minEventTime;
    self.scheduleForTask.reminderBeforeEventStart = schedule.reminderBeforeEventStart;
    self.scheduleForTask.scheduleOnWeekdays = schedule.scheduleOnWeekdays;
    self.scheduleForTask.scheduleOnWeekends = schedule.scheduleOnWeekends;
    self.scheduleForTask.startDate = schedule.startDate;
    self.scheduleForTask.timeslots = schedule.timeslots;    
}

-(void)insertValuesFromParentSchedule:(PLSchedule *)schedule
{
    if (self.scheduleForTask.endDate == nil)
            self.scheduleForTask.endDate = schedule.endDate;
    if (self.scheduleForTask.eventPadding == nil)
            self.scheduleForTask.eventPadding = schedule.eventPadding;
    if (self.scheduleForTask.maxEventTime == nil) 
            self.scheduleForTask.maxEventTime = schedule.maxEventTime;
    if (self.scheduleForTask.maxNoOfEventsPerDay == nil) 
            self.scheduleForTask.maxNoOfEventsPerDay  = schedule.maxNoOfEventsPerDay;
    if (self.scheduleForTask.maxNoOfEventsPerWeek == nil) 
            self.scheduleForTask.maxNoOfEventsPerWeek  = schedule.maxNoOfEventsPerWeek;
    if (self.scheduleForTask.minEventTime == nil) 
            self.scheduleForTask.minEventTime = schedule.minEventTime;
    if (self.scheduleForTask.reminderBeforeEventStart == nil)
            self.scheduleForTask.reminderBeforeEventStart = schedule.reminderBeforeEventStart;
    if (self.scheduleForTask.scheduleOnWeekdays == nil)
            self.scheduleForTask.scheduleOnWeekdays  = schedule.scheduleOnWeekdays;
    if (self.scheduleForTask.scheduleOnWeekends == nil) 
            self.scheduleForTask.scheduleOnWeekends  = schedule.scheduleOnWeekends;
    if (self.scheduleForTask.startDate == nil)
            self.scheduleForTask.startDate = schedule.startDate;
    if (self.scheduleForTask.timeslots == nil)
            self.scheduleForTask.timeslots = schedule.timeslots; 
    
}

-(BOOL)planTasks
{
    BOOL didSucceed;
    if ([self.subPlanners count] > 0) {
        for (PLOfTasks *subPlanner in self.subPlanners) {
            didSucceed = [subPlanner planTasks];
            
            //fast bail if we didn't make it
            if (!didSucceed) {
                return NO;
            }
        }
    } else {
        didSucceed = [self planThisTask];
    }
    
    return didSucceed;
    
}

-(BOOL)planThisTask
{
    PLAvailableTimeSlot *usableTimeSlot;
    
    while (self.timeLeftToPlan > 0) {
        self.scheduleForTask.timeLeft = self.timeLeftToPlan; //add the duration left so that we don't "overplan"
        usableTimeSlot = [self.availableTimes getNextSlotThatFitsSchedule:self.scheduleForTask];
        
        if (usableTimeSlot == nil) {
            return NO;
        }
        NSLog(@"Scheduling time for task:%@ from\n%@to\n%@",self.taskToPlan.title,usableTimeSlot.startTime,usableTimeSlot.endTime);
        [self.suggestedEvents addEventForTask:self.taskToPlan
                                     schedule:self.scheduleForTask 
                                         from:usableTimeSlot.startTime 
                                           to:usableTimeSlot.endTime];
        CGFloat durationOfEvent = [usableTimeSlot.endTime timeIntervalSinceDate:usableTimeSlot.startTime];
        NSAssert1(durationOfEvent > 0,@"The duration of an event is 0 or less!", nil);
        durationOfEvent = durationOfEvent / (60.0 * 60.0); //divide down into hours
        
        self.timeLeftToPlan -= durationOfEvent;
        NSLog(@"Timelefttoplan: %f",self.timeLeftToPlan);
    }
    
    return YES;
}

-(NSArray*)getSuggestedPlans
{
    NSArray* suggestedPlans = [NSArray arrayWithArray:self.suggestedEvents.suggestedEvents];
    return suggestedPlans;
}

-(PossibleEventsStorage*)suggestedEvents
{
    if (__suggestedEvents == nil) {
        __suggestedEvents = [[PossibleEventsStorage alloc] init];
    }
    
    return __suggestedEvents;
}

@end
