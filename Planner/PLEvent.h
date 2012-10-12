//
//  PLEvent.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class PLSchedule;

@interface PLEvent : NSObject

@property (strong, nonatomic) Task *plannedTask;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) PLSchedule *planningSchedule;

-(id)initForTask:(Task*)task schedule:(PLSchedule*)schedule from:(NSDate *)sDate to:(NSDate *)eDate;

@end
