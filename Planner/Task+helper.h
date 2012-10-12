//
//  Task+helper.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Task.h"

typedef enum {
    InsertTaskAtBeginning = 0,
    InsertTaskAtEnd = -1,
} INSERTTASK;

@interface Task (helper)

-(BOOL)addSubtask:(Task*)task atIndex:(NSInteger)index; //add task at index. If < 0, adds at the end of index
-(void)changeOrderInOwnerSubtasksToBePlacedBelow:(Task*)taskAbove; //if taskThatShouldBeBelow is the ownerTask, add at index 0!
-(NSNumber*)getAnId;
-(void)setSortKey:(NSString*)sortKey withRemainingLevelsToSet:(NSInteger)levels; //this will go through all subtasks of all fetched objects and give them the proper sortkey. Should be called only on the top goal
-(NSInteger)indentationUntil:(Task*)untilThisTask;
-(NSUInteger)getTotalAmountOfSubtasksWithinLevels:(NSInteger)levels;

-(NSMutableArray*)subTasksAtDepth:(NSInteger)depth; //used to determine if we should insert some more subtasks in the tableview when pushing tasks left

-(NSMutableArray*)getAllSubtasksWithinDepth:(NSUInteger)depth;

-(BOOL)shouldBeBelow:(Task*)taskWhichShouldBeAbove;
-(BOOL)shouldBeAddedTo:(Task*)taskWhichShouldBeParent;
@end
