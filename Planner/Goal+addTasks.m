//
//  Goal+addTasks.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Goal+addTasks.h"
#import "Task.h"

@implementation Goal (addTasks)

-(void)addSubtask:(Task*)task
{
    NSMutableOrderedSet* tempSet = [self mutableOrderedSetValueForKey:@"subTasks"];
    [tempSet addObject:task];
}

@end
