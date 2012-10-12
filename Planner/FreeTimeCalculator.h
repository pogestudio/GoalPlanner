//
//  FreeTimeCalculator.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvailableTimesContainer;

@interface FreeTimeCalculator : NSObject
{
    @private
    NSMutableArray *_timeSlots;
}



@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign) BOOL shouldCutAtMidnight;
@property (strong, nonatomic) NSArray *userEvents;

@property (strong, nonatomic) NSCalendar *currentCal;



-(id)initFromDate:(NSDate*)sDate to:(NSDate*)eDate;
-(AvailableTimesContainer*)calculateFreeTimeBetweenEvents;


@end