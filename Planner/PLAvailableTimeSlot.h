//
//  PLAvailableTimeSlot
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLSchedule;
@class PLAvailableTimeSlot;

typedef enum {
    InsertAtPositionBefore = 0,
    InsertAtPositionAfter
} InsertAtPosition;


@protocol AvailableTimeCreator
-(void)createNewTimeSlotFromDate:(NSDate*)startTime to:(NSDate*)endTime atPositionOf:(InsertAtPosition)pos of:(PLAvailableTimeSlot*)refSlot;
@end

@protocol OfferDefaultCalendar
-(NSCalendar*)defaultCalendar;
@end

typedef enum {
    AvailableTimeSchedulingNoSuccess = 0,
    AvailableTimeSchedulingSuccAndInsertTasksBefore,
    AvailableTimeSchedulingSuccAndInsertTasksAfter,
    AvailableTimeSchedulingSuccAndInsertTasksBeforeAndAfter,
    AvailableTimeSchedulingSuccAndInsertNoTasks,
} AvailableTimeScheduling;

@interface PLAvailableTimeSlot : NSObject

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (assign) BOOL isScheduled;

@property (strong, nonatomic) PLSchedule *tempSchedule;
@property (strong, nonatomic) id <AvailableTimeCreator,OfferDefaultCalendar> delegate;


-(id)initFromDate:(NSDate*)sDate to:(NSDate*)eDate;
-(BOOL)moldSlotToFitSchedule:(PLSchedule*)schedule; //we are taking for granted that if it fits, you schedule it! Since we already have split up events before and after.
@end
