//
//  Goal.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Task;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * sortKey;
@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) NSOrderedSet *subTasks;
@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)insertObject:(Task *)value inSubTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubTasksAtIndex:(NSUInteger)idx;
- (void)insertSubTasks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubTasksAtIndex:(NSUInteger)idx withObject:(Task *)value;
- (void)replaceSubTasksAtIndexes:(NSIndexSet *)indexes withSubTasks:(NSArray *)values;
- (void)addSubTasksObject:(Task *)value;
- (void)removeSubTasksObject:(Task *)value;
- (void)addSubTasks:(NSOrderedSet *)values;
- (void)removeSubTasks:(NSOrderedSet *)values;
@end
