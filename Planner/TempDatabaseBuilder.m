//
//  TempDatabaseBuilder.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempDatabaseBuilder.h"
#import "AppDelegate.h"

#import "Goal+addTasks.h"
#import "Schedule.h"
#import "Task.h"

@interface TempDatabaseBuilder (Private)
-(void)getMoc;
-(void)addTasksToGoal:(Goal*)goal;
-(void)addScheduleToGoal:(Goal*)goal;
@end


@implementation TempDatabaseBuilder

@synthesize moc;

-(void)insertTestStuff
{
    
     NSLog(@"Inserting stuff!");
    
    [self getMoc];
    
    Goal *goal = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Goal"
                  inManagedObjectContext:self.moc];
    
    goal.title = @"Första målet!";
    goal.id = [NSNumber numberWithInt:1];
    goal.sortKey = [NSNumber numberWithInt:1];

    [self addScheduleToGoal:goal];
    [self addTasksToGoal:goal];
    
    [self.moc save:nil];        
}

-(void)addScheduleToGoal:(Goal *)goal
{
    Schedule *newSchedule = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Schedule"
                             inManagedObjectContext:self.moc];
    
    
    newSchedule.startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    newSchedule.endDate = [NSDate dateWithTimeIntervalSinceNow:40000];
    newSchedule.eventPadding = [NSNumber numberWithInt:10];
    newSchedule.reminderBeforeEventStart = [NSNumber numberWithInt:10];
    newSchedule.minEventTime = [NSNumber numberWithInt:30];
    newSchedule.maxEventTime = [NSNumber numberWithInt:90];
    newSchedule.maxNoOfEventsPerDay = [NSNumber numberWithInt:1];
    newSchedule.maxNoOfEventsPerWeek = [NSNumber numberWithInt:3];
    newSchedule.scheduleOnWeekdays = [NSNumber numberWithBool:YES];
    newSchedule.scheduleOnWeekends = [NSNumber numberWithBool:YES];
    
    goal.schedule = newSchedule;
}

-(void)addTasksToGoal:(Goal *)goal
{
    Task *task1 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Task"
                   inManagedObjectContext:self.moc];
    
    task1.title = @"Titel1";
    task1.taskDescription = @"Desc1";
    task1.hasOrderIndependentSubTasks = [NSNumber numberWithBool:NO];
    task1.hasSubtasks = [NSNumber numberWithBool:NO];
    task1.time = [NSDate dateWithTimeIntervalSinceNow:0];
    task1.sortKey = [NSNumber numberWithInt:1];
    task1.isComplete = [NSNumber numberWithBool:NO];
    
    Task *task2 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Task"
                   inManagedObjectContext:self.moc];
    
    task2.title = @"Titel2";
    task2.taskDescription = @"Desc1";
    task2.hasOrderIndependentSubTasks = [NSNumber numberWithBool:NO];
    task2.hasSubtasks = [NSNumber numberWithBool:NO];
    task2.time = [NSDate dateWithTimeIntervalSinceNow:0];
    task2.sortKey = [NSNumber numberWithInt:2];
    task2.isComplete = [NSNumber numberWithBool:NO];

    Task *task3 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Task"
                   inManagedObjectContext:self.moc];
    
    task3.title = @"Titel3";
    task3.taskDescription = @"Desc1";
    task3.hasOrderIndependentSubTasks = [NSNumber numberWithBool:NO];
    task3.hasSubtasks = [NSNumber numberWithBool:NO];
    task3.time = [NSDate dateWithTimeIntervalSinceNow:0];
    task3.isComplete = [NSNumber numberWithBool:NO];
    task3.sortKey = [NSNumber numberWithInt:3];
    

    [goal addSubtask:task1];
    [goal addSubtask:task2];
    [goal addSubtask:task3];
    
}

-(void)getMoc
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    self.moc = appDel.managedObjectContext;
}

-(void)insertGoal
{
    
}


@end
