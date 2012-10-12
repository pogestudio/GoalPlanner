//
//  ManageTaskPlanningVC.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface ManageTaskPlanningVC : UITableViewController <EKCalendarChooserDelegate>

@property (strong, nonatomic) Task *goalToPlan;

//CELLS
@property (strong, nonatomic) IBOutlet UILabel *calendarsToScanLabel;
@property (strong, nonatomic) IBOutlet UILabel *calendarToSaveToLabel;

//DATA FOR PLANNING
@property (strong, nonatomic) NSArray *calendarsToScan;
@property (strong, nonatomic) EKCalendar *calendarToSaveTo;

@property (nonatomic) NSUInteger lastTappedCellTag;

-(IBAction)planTasks:(id)sender;

@end
