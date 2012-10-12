//
//  ManageTaskPlanningVC.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManageTaskPlanningVC.h"
#import "PLPLanner.h"
#import "Task.h"
#import "PLEvent.h"



#define CHOOSE_READ_CALS 97
#define CHOOSE_WRITE_CAL 98

@interface ManageTaskPlanningVC ()
@end

@implementation ManageTaskPlanningVC

@synthesize calendarsToScan;
@synthesize calendarToSaveTo;
@synthesize calendarsToScanLabel;
@synthesize calendarToSaveToLabel;
@synthesize lastTappedCellTag;

@synthesize goalToPlan;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setCalendarsToScan:nil];
    [self setCalendarToSaveTo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (tappedCell.tag == CHOOSE_WRITE_CAL || tappedCell.tag == CHOOSE_READ_CALS) {
        [self navigateToCalChooserWithCellTag:tappedCell.tag];
    }
    
    
}

-(void)navigateToCalChooserWithCellTag:(NSUInteger)cellTag;
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendarChooser *chooser;
    
    switch (cellTag) {
        case CHOOSE_READ_CALS:
        {
            chooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleMultiple displayStyle:EKCalendarChooserDisplayAllCalendars eventStore:eventStore];
            
            //Since it seems to be broken, we have to pass it a NSSet object
            chooser.selectedCalendars = [[NSSet alloc] init];
        }
            break;
        case CHOOSE_WRITE_CAL:
        {
            chooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly eventStore:eventStore];
        }
            break;
        default:
            NSAssert1(nil, @"Fix tapp cell in managetaskplanning!", nil);
            break;
    }
    
    chooser.delegate = self;
    chooser.showsCancelButton = NO;
    chooser.showsDoneButton = YES;
    self.lastTappedCellTag = cellTag;
    
    [self.navigationController pushViewController:chooser animated:YES];
}

-(IBAction)planTasks:(id)sender
{
    PLPLanner *planner = [[PLPLanner alloc] init];
    planner.theGoal = self.goalToPlan;
    
    planner.calendarsToScan = self.calendarsToScan;
    NSArray *plannedEvents = [planner scanAndPlan];
    if (plannedEvents == nil) {
        [self giveInfoOfFailure];
    }
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    for (PLEvent* event in plannedEvents) {
        NSLog(@"Event startTime:%@\nendTime:%@",
              [dateFormatter stringFromDate:event.startTime],
              [dateFormatter stringFromDate:event.endTime]);
    }
    
}

#pragma mark -
#pragma mark EKCalendarChooser Delegate
- (void)calendarChooserDidFinish:(EKCalendarChooser *)calendarChooser
{
    switch (self.lastTappedCellTag) {
        case CHOOSE_READ_CALS:
        {
            self.calendarsToScan = [calendarChooser.selectedCalendars allObjects];
            NSUInteger amountOfCalendarsChosen = [self.calendarsToScan count];
            self.calendarsToScanLabel.text = [NSString stringWithFormat:@"%d calendars chosen",amountOfCalendarsChosen];
        }
            break;
        case CHOOSE_WRITE_CAL:
        {
            NSAssert1([[calendarChooser.selectedCalendars allObjects] count] <= 1, @"More than one chosen read calendar!" , nil);
            self.calendarToSaveTo = [[calendarChooser.selectedCalendars allObjects] objectAtIndex:0];
            self.calendarToSaveToLabel.text = self.calendarToSaveTo.title;
        }
            break;
        default:
            break;
    }
    
    [calendarChooser.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark view related

-(IBAction)dismissView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
         
-(void)giveInfoOfFailure
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing planned" message:@"We could only plan about %XX percent of your goal due to lack of free time. Increase goal length to plan your goal successfully"
                                                   delegate:self cancelButtonTitle:@"Okaay" otherButtonTitles: nil];
	[alert show];	
}
@end
