//
//  TempDatabaseBuilder.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempDatabaseBuilder.h"
#import "AppDelegate.h"

#import "Task+helper.h"
#import "Schedule+helper.h"
#import "TimeSlot+ComponentHelper.h"

@interface TempDatabaseBuilder (Private)
-(void)getMoc;
-(void)addTasksToGoal:(Task*)goal;
-(void)addScheduleToGoal:(Task*)goal;
-(NSNumber*)getAnId;
@end


@implementation TempDatabaseBuilder

@synthesize moc;

-(void)insertTestStuff
{
    
     NSLog(@"Inserting stuff!");
    
    [self getMoc];
    
    Task *goal = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Task"
                  inManagedObjectContext:self.moc];
    
    goal.title = @"Bli utbildad!";
    goal.isGoal = [NSNumber numberWithBool:YES];

    [self addScheduleToGoal:goal];
    [self addTasksToGoal:goal];
    
    [self.moc save:nil];        
}

-(void)addScheduleToGoal:(Task *)goal
{
    Schedule *newSchedule = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Schedule"
                             inManagedObjectContext:self.moc];
    
    
    newSchedule.startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSUInteger days = 20;
    newSchedule.endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*days];
    newSchedule.eventPadding = [NSNumber numberWithInt:10];
    newSchedule.reminderBeforeEventStart = [NSNumber numberWithInt:10];
    newSchedule.minEventTime = [NSNumber numberWithInt:30];
    newSchedule.maxEventTime = [NSNumber numberWithInt:90];
    newSchedule.maxNoOfEventsPerDay = [NSNumber numberWithInt:1];
    newSchedule.maxNoOfEventsPerWeek = [NSNumber numberWithInt:3];
    newSchedule.scheduleOnWeekdays = [NSNumber numberWithBool:YES];
    newSchedule.scheduleOnWeekends = [NSNumber numberWithBool:YES];
    
    
    [self addTimeSlotsToSchedule:newSchedule];
    
    goal.schedule = newSchedule;
}

-(void)addTimeSlotsToSchedule:(Schedule*)schedule
{
    TimeSlot *timeSlot1 = [NSEntityDescription
                           insertNewObjectForEntityForName:@"TimeSlot"
                           inManagedObjectContext:self.moc];
    
    NSDateComponents *startTime1 = [[NSDateComponents alloc] init];
    [startTime1 setWeekday:DayTue];
    [startTime1 setHour:12];
    [startTime1 setMinute:00];
    
    
    NSDateComponents *endTime1 = [[NSDateComponents alloc] init];
    [endTime1 setWeekday:DayTue];
    [endTime1 setHour:13];
    [endTime1 setMinute:00];
    
    timeSlot1.startTime = startTime1;
    timeSlot1.endTime = endTime1;
    [schedule addTimeslot:timeSlot1];
    
    //object 2!
    TimeSlot *timeSlot2 = [NSEntityDescription
                           insertNewObjectForEntityForName:@"TimeSlot"
                           inManagedObjectContext:self.moc];
    
    NSDateComponents *startTime2 = [[NSDateComponents alloc] init];
    [startTime2 setWeekday:DayThu];
    [startTime2 setHour:15];
    [startTime2 setMinute:30];
    
    
    NSDateComponents *endTime2 = [[NSDateComponents alloc] init];
    [endTime2 setWeekday:DayThu];
    [endTime2 setHour:18];
    [endTime2 setMinute:30];
    
    timeSlot2.startTime = startTime2;
    timeSlot2.endTime = endTime2;
    [schedule addTimeslot:timeSlot2];
    
    //object 2!

    
    TimeSlot *timeSlot3 = [NSEntityDescription
                           insertNewObjectForEntityForName:@"TimeSlot"
                           inManagedObjectContext:self.moc];
    
    NSDateComponents *startTime3 = [[NSDateComponents alloc] init];
    [startTime3 setWeekday:DaySun];
    [startTime3 setHour:14];
    [startTime3 setMinute:27];
    
    
    NSDateComponents *endTime3 = [[NSDateComponents alloc] init];
    [endTime3 setWeekday:DaySun];
    [endTime3 setHour:18];
    [endTime3 setMinute:19];
    
    timeSlot3.startTime = startTime3;
    timeSlot3.endTime = endTime3;
    [schedule addTimeslot:timeSlot3];
    
    //object 2!

}

-(void)addTasksToGoal:(Task *)goal
{
    /*
     Get educated 
         Get good grades in uni
             Study 2 hours by yourself every day
             Plan out the weeks studying every sunday
         Read on extra curricular stuff
             Find out how others succeeded
                 Read biographies
                 Get a mentor
             Read books that you find interesting
         Utilise time so you don't slack
             Always have a resource of information with you
                 Find interesting magazines
                 Find newsfeeds
                 Download ebooks
         Find cultivating things to do on your spare time
             Find a fun sport
             Find friends to do it with
     */
    
    Task *getGoodGrades = [self createTaskWithTitle:@"Get good grades" andDesc:@"A+ in uni!!" thatShouldHaveSubtasks:YES];
   
    
    Task *studyEveryDay = [self createTaskWithTitle:@"Study every day" andDesc:@"Study some every day, and become master of the world" thatShouldHaveSubtasks:NO];
    Task *planStuff = [self createTaskWithTitle:@"Plan studying" andDesc:@"Every sunday, plan out what you need to study during the week, all handins and homeworks" thatShouldHaveSubtasks:NO];
    Task *extraCurricular = [self createTaskWithTitle:@"Read on extra curricular stuff" andDesc:@"Learn stuff not in school" thatShouldHaveSubtasks:NO];
    Task *findOutHowOthersSucceded  = [self createTaskWithTitle:@"Find out how others succeeded" andDesc:@"Learn how others have found their path" thatShouldHaveSubtasks:YES];
    Task *readBio  = [self createTaskWithTitle:@"Read Biographies" andDesc:@"Read others peoples path" thatShouldHaveSubtasks:NO];
    Task *getAMentor  = [self createTaskWithTitle:@"Search after a mentor" andDesc:@"Search for a mentor that might help you with career related choices" thatShouldHaveSubtasks:NO];
    Task *readInterestingBooks  = [self createTaskWithTitle:@"Read interesting books" andDesc:@"Expand your boundaries, and immerse yourself in that which you find interesting" thatShouldHaveSubtasks:NO];
    Task *utiliseTimeEfficiantly  = [self createTaskWithTitle:@"Utilise time efficiently" andDesc:@"Don't slack too much" thatShouldHaveSubtasks:YES];
    Task *alwaysHaveAResourceOfInfo  = [self createTaskWithTitle:@"Always bring some readable material with you" andDesc:@"In case you have a break, have something interesting on your hands!" thatShouldHaveSubtasks:YES];
    Task *findInterestingMagazines  = [self createTaskWithTitle:@"Find interesting magaines" andDesc:@"Spend 30 minutes every week to download interesting stuff" thatShouldHaveSubtasks:NO];
    Task *findNewsfeeds  = [self createTaskWithTitle:@"Find interesting newsfeeds" andDesc:@"Spend a few hours trying to find interesting news feeds" thatShouldHaveSubtasks:NO];
    Task *downloadEBooks  = [self createTaskWithTitle:@"Find eBooks" andDesc:@"Spend two hours every month finding good ebooks that motivates you!" thatShouldHaveSubtasks:NO];
    Task *findCultivatingThingsToDoOnSpareTime  = [self createTaskWithTitle:@"Find cultivating activities" andDesc:@"Find cultivating spare time activities, things that develop you in some way" thatShouldHaveSubtasks:YES];
    Task *findAFunSport  = [self createTaskWithTitle:@"Find a fun exercise" andDesc:@"Plan something fun that also makes you work out every week" thatShouldHaveSubtasks:NO];
    Task *findFriends  = [self createTaskWithTitle:@"Find friends" andDesc:@"Spend a few hours doing stuff on your own that makes you find new friends every week" thatShouldHaveSubtasks:YES];
    
    [goal addSubtask:getGoodGrades atIndex:InsertTaskAtEnd];
        [getGoodGrades addSubtask:studyEveryDay atIndex:InsertTaskAtEnd];
        [getGoodGrades addSubtask:planStuff atIndex:InsertTaskAtEnd];
    [goal addSubtask:extraCurricular atIndex:InsertTaskAtEnd];
        [extraCurricular addSubtask:findOutHowOthersSucceded atIndex:InsertTaskAtEnd];
            [findOutHowOthersSucceded addSubtask:readBio atIndex:InsertTaskAtEnd];
            [findOutHowOthersSucceded addSubtask:getAMentor atIndex:InsertTaskAtEnd];
        [extraCurricular addSubtask:readInterestingBooks atIndex:InsertTaskAtEnd];
    [goal addSubtask:utiliseTimeEfficiantly atIndex:InsertTaskAtEnd];
        [utiliseTimeEfficiantly addSubtask:alwaysHaveAResourceOfInfo atIndex:InsertTaskAtEnd];
            [alwaysHaveAResourceOfInfo addSubtask:findInterestingMagazines atIndex:InsertTaskAtEnd];
            [alwaysHaveAResourceOfInfo addSubtask:findNewsfeeds atIndex:InsertTaskAtEnd];
            [alwaysHaveAResourceOfInfo addSubtask:downloadEBooks atIndex:InsertTaskAtEnd];
    [goal addSubtask:findCultivatingThingsToDoOnSpareTime atIndex:InsertTaskAtEnd];
        [findCultivatingThingsToDoOnSpareTime addSubtask:findAFunSport atIndex:InsertTaskAtEnd];
        [findCultivatingThingsToDoOnSpareTime addSubtask:findFriends atIndex:InsertTaskAtEnd];
    
}

-(void)getMoc
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    self.moc = appDel.managedObjectContext;
}


/*
 
 What do we want to do?
 Create some useful info for the temporary goal
 
 Useful info is: subtasks

 Different levels of schedule.
 
 
 */

-(Task*)createTaskWithTitle:(NSString*)title andDesc:(NSString*)desc thatShouldHaveSubtasks:(BOOL)hasSubtasks
{
    Task *newTask = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Task"
                   inManagedObjectContext:self.moc];

    newTask.title = title;
    newTask.taskDescription = desc;
    newTask.hasOrderIndependentSubTasks = [NSNumber numberWithBool:NO];
    newTask.hasSubtasks = [NSNumber numberWithBool:hasSubtasks];
    newTask.duration =  [NSNumber numberWithFloat:1.5];
    newTask.isComplete = [NSNumber numberWithBool:NO];
    
    return newTask;

}


@end
