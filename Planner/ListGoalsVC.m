//
//  ListGoalsVC.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ListGoalsVC.h"
#import "ListTasksVC.h"

#import "TempDatabaseBuilder.h"
#import "Goal.h"
#import "Task.h"

@interface ListGoalsVC ()
-(void)executeFetchRequest;
-(void)insertTemporaryGoal;

@end

@implementation ListGoalsVC

@synthesize addButton;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDel.managedObjectContext;
    }
    
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self executeFetchRequest];
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
    return 1;
}

-(void)executeFetchRequest
{
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortKey" ascending:NO];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSPredicate *fetchPred = [NSPredicate predicateWithFormat:@"id > 0"];
    fetchRequest.predicate = fetchPred;
    
    
    NSFetchedResultsController *fetchContr = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController = fetchContr;
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0)
    {
        TempDatabaseBuilder *dataBuilder = [[TempDatabaseBuilder alloc] init];
        [dataBuilder insertTestStuff];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numberOfFetchedObjects =  [[self.fetchedResultsController fetchedObjects] count];
    return numberOfFetchedObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Goal *goalForCell = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = goalForCell.title;
    
    return cell;
}

-(IBAction)addNewGoal
{
    NSLog(@"ADD NEW GOAL");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    [self.tableView setEditing:editing animated:animate];
    
    if (editing) {
        self.navigationItem.leftBarButtonItem = self.addButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark --
#pragma mark Set up Next View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Task VC"])
	{
        ListTasksVC *listTasksVC = segue.destinationViewController;
        listTasksVC.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *selectedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        listTasksVC.parentTask = selectedTask;
        listTasksVC.title = selectedTask.title;
        
	} else {
        NSAssert1(nil,@"Should never be here, something is wrong with prepareForSegue", nil);

    }
}

@end
