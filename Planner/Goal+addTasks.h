//
//  Goal+addTasks.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Goal.h"

@class Task;

@interface Goal (addTasks)

-(void)addSubtask:(Task*)task;

@end
