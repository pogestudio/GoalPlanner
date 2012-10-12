//
//  FreeTimeContainer.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/*
 
 The responsibility of this class is to keep a list of available times
 and offer a nice interface for the Planners of Tasks.
 
 */

#import <Foundation/Foundation.h>
#import "PLAvailableTimeSlot.h"

@class PLSchedule;

@interface AvailableTimesContainer : NSObject <AvailableTimeCreator, OfferDefaultCalendar>

@property (strong, nonatomic) NSMutableArray *availableTimes;
@property (assign) NSInteger lastAccessedIndex;
@property (strong, nonatomic) NSCalendar *defaultCalendar;

-(id)initWithAvailableTimes:(NSMutableArray*)times;
-(PLAvailableTimeSlot*)getNextSlotThatFitsSchedule:(PLSchedule*)schedule;


@end
