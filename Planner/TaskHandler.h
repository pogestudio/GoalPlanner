//
//  TaskHandler.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Task;


@interface TaskHandler : NSObject 

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) Task *theHeadTask;
@property (retain, nonatomic) NSMutableArray *tasksForTableView;
@property (nonatomic) NSUInteger depthToShow;

-(id)initForTableView:(UITableView*)tableView;
-(void)fillTaskHandler;
-(Task*)objectAtIndexPath:(NSIndexPath*)indexPath;
-(void)deleteTaskAtIndexPath:(NSIndexPath*)indexPath;
-(void)changeObjectFrom:(NSIndexPath*)fromIP to:(NSIndexPath*)toIP;

-(NSUInteger)indentationForCellAtIndexPath:(NSIndexPath*)indexPath;

-(void)moveObjectsInTableViewArray:(NSArray*)objects row:(NSUInteger)fromRow to:(NSUInteger)toRow;



//FROM TASKCELL
-(BOOL)tryToIncreaseDepthOfTask:(Task *)swipedTask; //add task to subtasks of the task in the cell above
-(BOOL)tryToDecreaseDepthOfTask:(Task *)swipedTask; //add tasks to subtasks of the ownertask of the ownertask, i.e. decrease depth

@end
