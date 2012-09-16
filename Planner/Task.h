//
//  Task.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Goal.h"

@class Goal;

@interface Task : Goal

@property (nonatomic, retain) NSNumber * hasOrderIndependentSubTasks;
@property (nonatomic, retain) NSNumber * hasSubtasks;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Goal *ownerTask;

@end
