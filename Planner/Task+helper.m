//
//  Task+helper.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Task+helper.h"

@implementation Task (helper)

-(BOOL)addSubtask:(Task*)task atIndex:(NSInteger)index
{
    
    NSLog(@"Self.title: %@",self.title);
    NSMutableOrderedSet* tempSet = [self mutableOrderedSetValueForKey:@"subTasks"];
    
    for (Task* task in tempSet) {
        NSLog(@"Before change, subtasks: %@",task.title);
    }
    BOOL canAdd = YES;
    if (![tempSet containsObject:task] && self != task) {
        if (index < 0) {
            [tempSet addObject:task];
        } else {
            [tempSet insertObject:task atIndex:index];
        }
    } else {
        canAdd = NO;
    }
    
    for (Task* task in tempSet) {
        NSLog(@"After change, subtasks: %@",task.title);
    }
    
    return canAdd;
}

-(void)changeOrderInOwnerSubtasksToBePlacedBelow:(Task*)taskAbove
{
    NSLog(@"Task above: %@",taskAbove.title);
    Task *ownerTask = self.ownerTask;
    NSAssert1([ownerTask.subTasks containsObject:self], @"ERROR: 498 or somethinglolwut", nil);
    
    for (Task* task in ownerTask.subTasks) {
        NSLog(@"Before change, subtasks: %@",task.title);
    }
    
    NSMutableOrderedSet *ownerSubtasks = [ownerTask mutableOrderedSetValueForKey:@"subTasks"];
    NSUInteger currentIndex = [ownerSubtasks indexOfObject:self];
    NSUInteger newIndex;
    if (taskAbove == ownerTask) {
        newIndex = 0;
    } else {
        newIndex = [ownerSubtasks indexOfObject:taskAbove];
    }
    
    if (currentIndex > newIndex) { //add one if we are moving from below!
        newIndex++;
    }
    
    NSLog(@"Current index:: %d",currentIndex);
    NSLog(@"New index:: %d",newIndex);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:currentIndex];
    [ownerSubtasks moveObjectsAtIndexes:indexSet toIndex:newIndex];
    
    for (Task* task in ownerTask.subTasks) {
        NSLog(@"After change, subtasks: %@",task.title);
    }
    
}


-(NSNumber*)getAnId
{    
    NSInteger number = rand() % 1239123;
    return [NSNumber numberWithInt:number];

}

-(void)setSortKey:(NSString*)sortKey withRemainingLevelsToSet:(NSInteger)levels
{
    self.sortKey = sortKey;
    if (levels == 0) {
        return;
    } 
    
    NSArray *arrayOfSubTasks = [self.subTasks array];
    levels--;
    for (NSUInteger index = 0; index < [arrayOfSubTasks count] ; index++)
    {
        Task *taskAtIndex = [arrayOfSubTasks objectAtIndex:index];
        NSString *sortKeyForTask = [NSString stringWithFormat:@"%@|%d",sortKey,index];
        [taskAtIndex setSortKey:sortKeyForTask withRemainingLevelsToSet:levels];
    }
}

-(NSInteger)indentationUntil:(Task *)untilThisTask
{
    NSInteger level;
    if (self == untilThisTask) {
        level = -1;  //when we reach this level, drop it down a level so we have a tight left hug
    } else {
        level = 1 + [self.ownerTask indentationUntil:untilThisTask]; 
    }
    
    return level;
}

-(NSUInteger)getTotalAmountOfSubtasksWithinLevels:(NSInteger)levels
{
    
    //if current task is visible (levels is 0 or above) then add one
    //then call kids
    
    if (levels < 0)
    {
        return 0;
    }
    
    NSUInteger numberOftasks = 1; //this task
    
    levels--;
    for (Task* subTask in self.subTasks)
    {
        numberOftasks += [subTask getTotalAmountOfSubtasksWithinLevels:levels];
    }
    
    return numberOftasks;
}

-(NSMutableArray*)subTasksAtDepth:(NSInteger)depth
{
    NSMutableArray *arrayToReturn;
    if (depth == 1) {
        arrayToReturn = [NSMutableArray arrayWithArray:[self.subTasks array]];
    } else if(depth <= 0)
    { //special case if we are accidentally calling with a level too low
        arrayToReturn = [NSMutableArray array];
    }
    else {
        depth--;
        arrayToReturn = [[NSMutableArray alloc] init];
        for (Task *subtask in self.subTasks) {
            NSMutableArray *subTasksOfRightDepth = [subtask subTasksAtDepth:depth];
            for (Task* subSubTask in subTasksOfRightDepth) {
                [arrayToReturn addObject:subSubTask];
            }
        }
    }
    
    return arrayToReturn;
}

-(NSMutableArray*)getAllSubtasksWithinDepth:(NSUInteger)depth
{
    NSLog(@"Title:%@",self.title);
    NSMutableArray *arrayToReturn;
    if (depth == 1) {
        arrayToReturn = [NSMutableArray arrayWithArray:[self.subTasks array]];
    } else if(depth <= 0)
    { //special case if we are accidentally calling with a level too low
        arrayToReturn = [NSMutableArray array];
    }
    else {
        depth--;
        arrayToReturn = [[NSMutableArray alloc] init];
        for (Task *subtask in self.subTasks) {
            [arrayToReturn addObject:subtask];
            NSMutableArray *subTasksOfRightDepth = [subtask getAllSubtasksWithinDepth:depth];
            for (Task* subSubTask in subTasksOfRightDepth) {
                [arrayToReturn addObject:subSubTask];
            }
        }
    }
    
    return arrayToReturn;

}

-(BOOL)shouldBeBelow:(Task *)taskWhichShouldBeAbove
{
    NSLog(@"Self.title: %@",self.title);
    NSLog(@"taskWhichShouldBeAbve.title: %@",taskWhichShouldBeAbove.title);

    //if task have same owner, change index
    //if task does not have same owner, add after task
    
    if (self.ownerTask == taskWhichShouldBeAbove.ownerTask || self.ownerTask == taskWhichShouldBeAbove) {
        [self changeOrderInOwnerSubtasksToBePlacedBelow:taskWhichShouldBeAbove];
    } else {    
        NSLog(@"taskWhichShouldBeAbve.ownertask: %@",taskWhichShouldBeAbove.ownerTask.title);

        [self shouldBeAddedTo:taskWhichShouldBeAbove.ownerTask];
        [self changeOrderInOwnerSubtasksToBePlacedBelow:taskWhichShouldBeAbove];
    }
    
    return YES;
}

-(BOOL)shouldBeAddedTo:(Task *)taskWhichShouldBeParent
{
    
    NSLog(@"Self.title: %@",self.title);
    NSLog(@"taskWhichShouldBeParent.title: %@",taskWhichShouldBeParent.title);

    if ([taskWhichShouldBeParent.subTasks containsObject:self]) {
        [self changeOrderInOwnerSubtasksToBePlacedBelow:taskWhichShouldBeParent];
    }
    else {
        [taskWhichShouldBeParent addSubtask:self atIndex:InsertTaskAtBeginning];
    }
    
    return YES;
}

@end
