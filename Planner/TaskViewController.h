//
//  TaskViewController.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class Task;

@interface TaskViewController : UITableViewController


@property (strong, nonatomic) Task *taskToUse;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)userAsksToDismissView:(id)sender;

@end
