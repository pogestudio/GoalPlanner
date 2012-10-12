//
//  PossibleEventsStorage.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



/*
 
 The responsibility of this class is to store possible events during planning of tasks.
 When the planning is done, the array of this object should be passed on to a handler which
 presents to VC and pushes to planning.
 
 */

#import <Foundation/Foundation.h>

@class Task;
@class PLSchedule;

@interface PossibleEventsStorage : NSObject

@property (strong, nonatomic) NSMutableArray *suggestedEvents;

-(void)addEventForTask:(Task*)task schedule:(PLSchedule*)schedule from:(NSDate*)sDate to:(NSDate*)eDate;
@end
