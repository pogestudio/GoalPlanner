//
//  TimeSlot.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface TimeSlot : NSManagedObject

@property (nonatomic, retain) id endTime;
@property (nonatomic, retain) id startTime;
@property (nonatomic, retain) Schedule *ownerSchedule;

@end
