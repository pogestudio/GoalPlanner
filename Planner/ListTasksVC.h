//
//  ListTasksVC.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "TaskCell.h"

@class Task;
@class TaskHandler;
@class TaskToolbar;

@interface ListTasksVC : UITableViewController <TaskCellDelegate>

@property (strong, nonatomic) Task *parentTask;
@property (strong, nonatomic) TaskHandler *taskHandler;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL shouldShowDeletion;

@property (nonatomic, strong) IBOutlet TaskToolbar *toolbar;

-(IBAction)tempInsertObject;

@end
