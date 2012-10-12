//
//  Schedule.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task, TimeSlot;

@interface Schedule : NSManagedObject

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
@property (nonatomic, retain) Task *ownerSchedule;
@property (nonatomic, retain) NSOrderedSet *timeslots;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)insertObject:(TimeSlot *)value inTimeslotsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTimeslotsAtIndex:(NSUInteger)idx;
- (void)insertTimeslots:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTimeslotsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTimeslotsAtIndex:(NSUInteger)idx withObject:(TimeSlot *)value;
- (void)replaceTimeslotsAtIndexes:(NSIndexSet *)indexes withTimeslots:(NSArray *)values;
- (void)addTimeslotsObject:(TimeSlot *)value;
- (void)removeTimeslotsObject:(TimeSlot *)value;
- (void)addTimeslots:(NSOrderedSet *)values;
- (void)removeTimeslots:(NSOrderedSet *)values;
@end
