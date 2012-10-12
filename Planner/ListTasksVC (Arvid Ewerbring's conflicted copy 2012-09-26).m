//
//  ListTasksVC.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListTasksVC.h"
#import "TaskCell.h"
#import "TaskHandler.h"

#import "Task+helper.h"

#define NUMBER_OF_LEVELS_TO_SHOW 4

@interface ListTasksVC ()
-(void)executeFetchRequest;
-(void)sortObjects;
@end

@implementation ListTasksVC

@synthesize parentTask;
@synthesize taskHandler;
@synthesize managedObjectContext;
@synthesize shouldShowDeletion;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.taskHandler fillTaskHandler];
    [self layoutSubviewsForAllVisibleCellsInTableviewWithAnimation:NO];
    self.shouldShowDeletion = NO;
    
    self.tableView.editing = YES;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.taskHandler = [[TaskHandler alloc] initForTableView:self.tableView];
    self.taskHandler.theHeadTask = self.parentTask;
    self.taskHandler.managedObjectContext = self.managedObjectContext;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger numberOfObjects = [self.taskHandler.tasksForTableView count];
    return numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self setUpCell:cell forIndexPath:indexPath];
    
    return cell;
}

-(void)setUpCell:(TaskCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"setUpCell, row:%d",indexPath.row);
    NSLog(@"setUpCell, tasksForTableView count: %d",[self.taskHandler.tasksForTableView count]);
          
    Task *taskForRow = [self.taskHandler objectAtIndexPath:indexPath];
    
    [cell setUpcellWithTask:taskForRow andParentTask:self.parentTask];
    
    //add delegate so that we can update subviews of all visible cells when changes are made
    cell.showsReorderControl = YES;
    cell.taskDelegate = self;
    cell.taskHandler = self.taskHandler;
}

#pragma mark -
#pragma mark TableView Editing


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shouldShowDeletion) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
    
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.taskHandler changeObjectFrom:fromIndexPath to:toIndexPath];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    Task *taskAtCell = [self.taskHandler.tasksForTableView objectAtIndex:sourceIndexPath.row];
    NSUInteger cellIndentation = [self.taskHandler indentationForCellAtIndexPath:sourceIndexPath];
    NSUInteger indentationUntilScreenOutOfBounds = self.taskHandler.depthToShow - cellIndentation;
    NSArray *arrayOfSubTasks = [taskAtCell getAllSubtasksWithinDepth:indentationUntilScreenOutOfBounds];
    
    for (Task* task in arrayOfSubTasks) {
        NSLog(@"SubtaskArray: %@",task.title);
    }
    
    Task *taskWeAreTryingToMoveUnderNeath = [self.taskHandler.tasksForTableView objectAtIndex:proposedDestinationIndexPath.row];
    
    NSIndexPath *okIndexPath;
    if ([arrayOfSubTasks containsObject:taskWeAreTryingToMoveUnderNeath])
    {
        okIndexPath =  sourceIndexPath;
    } else {
        okIndexPath = proposedDestinationIndexPath;
    }
    
    return okIndexPath;
}



-(IBAction)tempInsertObject
{
    NSLog(@"Inserting new task in temporary function");
    Task *newTask = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Task"
                   inManagedObjectContext:self.managedObjectContext];
    
    
    newTask.title = [NSString stringWithFormat:@"Title %d",[[newTask getAnId] intValue]];
    newTask.taskDescription = @"Desc1";

    
    [self.parentTask addSubtask:newTask atIndex:InsertTaskAtBeginning];
    [self.managedObjectContext save:nil];    
}

#pragma mark -
#pragma mark Set up Next View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Go to deeper task"])
	{
        ListTasksVC *listTasksVC = segue.destinationViewController;
        listTasksVC.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *selectedTask = [self.taskHandler objectAtIndexPath:indexPath];
        
        listTasksVC.parentTask = selectedTask;
        listTasksVC.title = selectedTask.title;
        
	} else {
        NSAssert1(nil,@"Should never be here, something is wrong with prepareForSegue", nil);
    }
}

#pragma mark -
#pragma mark TaskCellDelegate
-(void)layoutSubviewsForAllVisibleCellsInTableviewWithAnimation:(BOOL)animated
{
    NSArray *arrayOfCells = self.tableView.visibleCells;
    for (TaskCell *cell in arrayOfCells)
    {
        [cell indentToRightLevelsWithAnimation:animated];
    }
}


@end
