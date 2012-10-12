//
//  PLSchedule.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/*
 
 This is simply a copy of Schedule.h, with some additional details, for non-core data usage. We want to use it and fill in non-empty values
 with values from owner nodes, but do not want to edit the original data (pre-planning).
 
 So, we use a copy of this instead.
 
 */
#import <Foundation/Foundation.h>



@interface PLSchedule : NSObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * eventPadding;
@property (nonatomic, retain) NSNumber * maxEventTime;
@property (nonatomic, retain) NSNumber * maxNoOfEventsPerDay;
@property (nonatomic, retain) NSNumber * maxNoOfEventsPerWeek;
@property (nonatomic, retain) NSNumber * minEventTime;
@property (nonatomic, retain) NSNumber * reminderBeforeEventStart;
@property (nonatomic, retain) NSNumber * scheduleOnWeekdays;
@property (nonatomic, retain) NSNumber * scheduleOnWeekends;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSOrderedSet *timeslots;

@property (assign) CGFloat timeLeft;

-(NSUInteger)getPaddingInSeconds;

@end
