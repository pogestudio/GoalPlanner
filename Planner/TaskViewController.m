//
//  TaskViewController.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/* constants
 *
 */

#define NUMBER_OF_CELLS_IN_FIRST_SECTION 2
#define NUMBER_OF_CELLS_IN_SECOND_SECTION 2
#define NUMBER_OF_STATIC_CELLS_IN_THIRD_SECTION 1

#import "TaskViewController.h"
#import "TitleCell.h"
#import "DescriptionCell.h"
#import "TimeRequiredCell.h"
#import "SwitchControlCell.h"

@interface TaskViewController ()
-(void)setUpCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
-(UITableViewCell*)createCellForIndexPath:(NSIndexPath*)indexPath;
-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;

@end

typedef enum {
    CELL_FOR_TITLE = 0,
    CELL_FOR_DESCRIPTION,
} CELLS_FOR_TITLE_SECTION;

typedef enum {
    CELL_FOR_TIME = 0,
    CELL_FOR_SCHEDULE,
} CELLS_FOR_SCHEDULING;

typedef enum {
    CELL_FOR_SUBTASK = 0,
    CELL_FOR_ORDER_INDEPENDENCE,
} CELLS_FOR_SUBTASKS;

typedef enum {
    SECTION_TITLE = 0,
    SECTION_TIME,
    SECTION_SUBTASKS,
    SECTION_MAX,
} SECTIONS_FOR_TABLE;






@implementation TaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case SECTION_TITLE:
            numberOfRows = NUMBER_OF_CELLS_IN_FIRST_SECTION;
            break;
        case SECTION_TIME:
            numberOfRows = NUMBER_OF_CELLS_IN_SECOND_SECTION;
            break;
        case SECTION_SUBTASKS:
            numberOfRows = NUMBER_OF_STATIC_CELLS_IN_THIRD_SECTION;
#warning temporary fix
            numberOfRows++; //to get order independence
            break;
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with numberOfRowsInSection", nil);
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [self createCellForIndexPath:indexPath];
        NSAssert1(nil,@"I thought you alwys got a cell from queue!", nil);
    }
    
    [self setUpCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.bounds.size.height;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark --
#pragma mark Configure Cells

-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath
{
    NSString *cellIdentifier;
    
    
    switch (indexPath.section) {
        case SECTION_TITLE:
        {
            
            switch (indexPath.row) {
                case CELL_FOR_TITLE:
                {
                    cellIdentifier = @"TitleCell";
                }
                    break;
                case CELL_FOR_DESCRIPTION:
                {
                    cellIdentifier = @"DescriptionCell";
                }
                    break;
                default:
                    NSAssert1(nil,@"Should never be here, something is wrong with getCellDescription", nil);
                    break;
            }
            
        }
            break;
        case SECTION_TIME:
        {
            switch (indexPath.row) {
                case CELL_FOR_TIME:
                {
                    cellIdentifier = @"TimeCell";
                }
                    break;
                case CELL_FOR_SCHEDULE:
                {
                    cellIdentifier = @"ScheduleCell";
                }
                    break;
                default:
                    NSAssert1(nil,@"Should never be here, something is wrong with getCellDescription", nil);
                    break;
            }        }
            break;
            
        case SECTION_SUBTASKS:
        {
            switch (indexPath.row) {
                case CELL_FOR_SUBTASK:
                {
                    cellIdentifier = @"SwitchControlCell";
                }
                    break;
                case CELL_FOR_ORDER_INDEPENDENCE:
                {
                    cellIdentifier = @"SwitchControlCell";
                }
                    break;
                default:
                    NSAssert1(nil,@"Should never be here, something is wrong with getCellDescription", nil);
                    break;
            }
        }
            break;
            
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with getCellDescription", nil);
            break;
    }
    
    return cellIdentifier;
}

-(UITableViewCell*)createCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell;
    NSLog(@"%d",indexPath.section);
    
    if (indexPath.section == 0) {
        if (indexPath.row == CELL_FOR_TITLE) {
            cell = [[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        } else if (indexPath.row == CELL_FOR_DESCRIPTION) {
            cell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
    } else if (indexPath.section == 1) {
        cell = [[TimeRequiredCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }   
   
    return cell;
}

-(void)setUpCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{

}

@end
