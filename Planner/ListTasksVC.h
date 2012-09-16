//
//  ListTasksVC.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class Goal;

@interface ListTasksVC : CoreDataTableViewController

@property (strong, nonatomic) Goal *parentTask;

@end
