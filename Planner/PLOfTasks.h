//
//  PLOfTasks.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class Schedule;
@class PLSchedule;
@class AvailableTimesContainer;
@class PossibleEventsStorage;

@interface PLOfTasks : NSObject

{
    @private
    PLOfTasks *_ownerPlanner; //Set on init, when building tree.
}

@property (assign) CGFloat timeLeftToPlan;
@property (strong, nonatomic) NSMutableArray *subPlanners;
//put constraints if needed
@property (strong, nonatomic) PLSchedule *scheduleForTask;
@property (strong, nonatomic) NSDate *endTime; //Set endTime when we plan the last time period. This is so the task after us knows when to start
@property (strong,nonatomic) Task *taskToPlan;
@property (strong, nonatomic) AvailableTimesContainer *availableTimes;
@property (strong, nonatomic) PossibleEventsStorage *suggestedEvents;


-(void)pushDownSchedule:(PLSchedule*)scheduleOrNil; //a recursive function that traverses the tree. If our own schedule is not completely filled in, we copy those values from schedule.
-(BOOL)planTasks;
-(void)buildStructure;

-(id)initWithTask:(Task *)task byOwner:(PLOfTasks *)ownerOrNil availableTimes:(AvailableTimesContainer*)times;


-(NSArray*)getSuggestedPlans;
@end
