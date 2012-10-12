//
//  TaskHandler.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskHandler.h"
#import "TaskCell.h"

#import "Task+helper.h"
#import "NSMutableArray+moveObject.h"


#define NUMBER_OF_SECTIONS 1

@interface TaskHandler ()
-(void)executeFetchRequest;
-(void)sortTasks;
-(NSArray*)sortThisArray:(NSArray*)arrayToSort;
-(void)prepareResultsForSorting;

//table manipulation
-(void)removeTasksAndAllItsSubtasksFromTableview:(Task*)taskToBeRemoved withAnimation:(UITableViewRowAnimation)rowAnimation;
-(void)investigateIfWeShouldInsertMoreSubtasksInTableview;
-(void)removeCellsThatAreTooDeepLevelAfterTask:(Task*)task;
-(void)removeTasksFromDSAndTBVWithRange:(NSRange)range andAnimation:(UITableViewRowAnimation)animation;
-(void)moveObjects:(NSArray*)from row:(NSUInteger)fromRow to:(NSUInteger)toRow;

//Task manipulation
-(void)addSubtasksAfterTaskToItself:(Task*)thisTask;
@end


@implementation TaskHandler

@synthesize managedObjectContext = __managedObjectContext;
@synthesize tableView = __tableView;
@synthesize theHeadTask = __theHeadTask;
@synthesize tasksForTableView = __tasksForTableView;
@synthesize depthToShow = __depthToShow;

-(id)initForTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.depthToShow = 4;
    }
    
    return self;
}

#pragma mark -
#pragma mark Getters and Setters
-(void)setTableView:(UITableView *)tableView
{
    __tableView = tableView;
    
}

#pragma mark -
#pragma mark Get Tasks
-(void)fillTaskHandler
{
    NSArray* fetchedTasks = [self executeFetch];
    [self prepareResultsForSorting];
    self.tasksForTableView = [NSMutableArray arrayWithArray:[self sortThisArray:fetchedTasks]];

}

-(NSArray*)executeFetch
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSPredicate *fetchPred = [self predicateForTheRightAmountOfLevels];
    fetchRequest.predicate = fetchPred;
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil)
    {
        // Deal with error...
        NSAssert(nil,@"some weird stuff is uppp in taskhandlers fetchrequest",nil);
    }
    
    //[self printTitleNamesOfArray:fetchedObjects];
    //[self printTitleNamesOfSubTasks];

    return fetchedObjects;    
}

-(void)prepareResultsForSorting
{
    //set sort keys, so that we can sort it using that
    [self.theHeadTask setSortKey:@"1" withRemainingLevelsToSet:self.depthToShow];
    [self.managedObjectContext save:nil];}

-(NSArray*)sortThisArray:(NSArray *)arrayToSort
{        
    NSArray *sortedArray = [arrayToSort sortedArrayUsingComparator:^(Task* task1, Task* task2)
    
    {
        NSString *str1 = task1.sortKey;
        NSString *str2 = task2.sortKey;
        
        NSArray *task1Sort = [str1 componentsSeparatedByString:@"|"];
        NSArray *task2Sort = [str2 componentsSeparatedByString:@"|"];
        
        
        NSUInteger lengthOfTask1 = [task1Sort count];
        NSUInteger lengthOfTask2 = [task2Sort count];
        //continue loop until you call break
        NSUInteger arrayIndex = 0;
        
        while (arrayIndex < lengthOfTask1 && arrayIndex < lengthOfTask2) {
            NSUInteger task1SortValue = [[task1Sort objectAtIndex:arrayIndex] intValue];
            NSUInteger task2SortValue = [[task2Sort objectAtIndex:arrayIndex] intValue];            
           
            if (task1SortValue > task2SortValue)
            {
                return NSOrderedDescending;
            } else if (task1SortValue < task2SortValue) 
            {
                return NSOrderedAscending;
            }
            arrayIndex++;
        }
        
        //if we are here, one task have a sort key longer than the other.
        //that means it is a child of some level of the other.
        //return the one with the shortest sort key
        if (lengthOfTask1 > lengthOfTask2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
        
    }];
    
    return sortedArray;
}

#pragma mark Temporary helperMethods to figure out stuff

-(void)printTitleNamesOfArray:(NSArray*)array
{
    NSLog(@"Names of fetch");
    for (Task *task in array)
    {
        NSLog(@"Title: %@",task.title);
    }
}
-(void)printTitleNamesOfSubTasks
{
        NSLog(@"Names of Subtasks");
    if ([self.theHeadTask.subTasks count] >0) {
        for (Task *subtask in [self.theHeadTask.subTasks array]) {
            if ([subtask.subTasks count] >0)
            {
                for (Task *subtask in [self.theHeadTask.subTasks array])
                {
                    NSLog(@"Title2: %@",subtask.title);
                }
            }
            NSLog(@"Title: %@",subtask.title);

        }
    }
}

#pragma mark END OF TEMP


-(NSPredicate*)predicateForTheRightAmountOfLevels
{
    NSInteger amountOfLevels = self.depthToShow;
    NSMutableArray *predicateArray = [NSMutableArray array];
    
    for (NSInteger levelCounter = 1; levelCounter <= amountOfLevels; levelCounter++) {
        NSMutableString *predicateString = [NSMutableString stringWithFormat:@"(ownerTask"];
        for (NSInteger ownerTaskCounter = 1; ownerTaskCounter < levelCounter; ownerTaskCounter++) {
            [predicateString appendString:@".ownerTask"];
        }
        [predicateString appendString:@" = %@)"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString,
                                  self.theHeadTask];
        
        [predicateArray addObject:predicate];
    } 
    
    NSPredicate *compundedPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
        
    return compundedPredicates;
}



-(Task*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    //presently only sorting on rows, ignoring sections
    NSAssert1(NUMBER_OF_SECTIONS == 1,@"Our logic about sections is FLAWED. FIX",nil);
    
    NSInteger row = indexPath.row;
    
    Task *taskForRow = [self.tasksForTableView objectAtIndex:row];
    
    return taskForRow;
    
}

#pragma mark -
#pragma mark Task Manipulation
-(BOOL)tryToIncreaseDepthOfTask:(Task *)swipedTask
{
    //if task is swiped right we want to try to
    //1 try to add to the task in the index above this one
    //if cannot (already a child)
    //2 return a bool
    
    //BAIL OUT if we are top object of screen
    NSUInteger currentTaskIndexOfTableArray = [self.tasksForTableView indexOfObject:swipedTask];
    if (currentTaskIndexOfTableArray == 0) {
        return NO;
    }
    
    NSArray *arrayWhichTaskIsMemberIn = [swipedTask.ownerTask.subTasks array];

    NSUInteger indexOfCurrentTask = [arrayWhichTaskIsMemberIn indexOfObject:swipedTask];
    if (indexOfCurrentTask == 0) {
        //we are already top child and cannot become a "deeper" child -> BAIL OUT
        return NO;
    }
    
    //we can add the task to the task that is one position earlier in the parents subtask set
    NSUInteger indexOfTaskAbove = indexOfCurrentTask-1;
    Task *taskAbove = [arrayWhichTaskIsMemberIn objectAtIndex:indexOfTaskAbove];
    [taskAbove addSubtask:swipedTask atIndex:InsertTaskAtEnd];
    
    [self.managedObjectContext save:nil];
    
    //check if some tasks have gone "too far", and needs to be removed.
    [self removeCellsThatAreTooDeepLevelAfterTask:swipedTask];
    
    
    return YES;
}

-(BOOL)tryToDecreaseDepthOfTask:(Task *)swipedTask
{
    
    //if task is swiped left we want to try to
    //try to add ourselves to the parent of our parent
    
    //BAIL OUT if parent DOES NOT have a parent!
    Task *currentOwnerTask = swipedTask.ownerTask;
    Task *ownerOfOwner = currentOwnerTask.ownerTask;
    if (ownerOfOwner == nil) {
        return NO;
    }
    
    //we can add!
    [self addSubtasksAfterTaskToItself:swipedTask];
    
    //add ourselves to the proposed ownertask at the index after our current owner.
    NSUInteger indexOfCurrentOwner = [ownerOfOwner.subTasks indexOfObject:currentOwnerTask];
    NSUInteger newIndex = indexOfCurrentOwner + 1;
    
    [ownerOfOwner addSubtask:swipedTask atIndex:newIndex];
    
    //the relationships have shifted
    Task *previousOwner = currentOwnerTask;
    
    [self.managedObjectContext save:nil];

    //if the previous owner was theHeadTask, we should remove the swiped tasks and all it's subtasks from the tableview
    //if not, we might have to show some more tasks
    if (previousOwner == self.theHeadTask) {
        [self removeTasksAndAllItsSubtasksFromTableview:swipedTask withAnimation:UITableViewRowAnimationLeft];
    } else
    {
        [self investigateIfWeShouldInsertMoreSubtasksInTableview];   
    }

    return YES;
}

-(void)addSubtasksAfterTaskToItself:(Task *)thisTask
{
    //get all subtasks AFTER ourself in the current subtaskarray WE ARE IN. These are supposed to become the swiped tasks new children.
    Task *currentOwnerTask = thisTask.ownerTask;
    
    NSUInteger indexOfThis = [currentOwnerTask.subTasks indexOfObject:thisTask];
    NSUInteger subTasksAfterThis = [currentOwnerTask.subTasks count] - indexOfThis - 1; //-1 because the index is 0 based.
    NSRange rangeOfSubtasksAfterThis = {indexOfThis + 1,subTasksAfterThis}; //+1 because we still have not moved "thisTask" away from ownerTask
    
    NSIndexSet *indexSetOfSubtasksAfterThis = [NSIndexSet indexSetWithIndexesInRange:rangeOfSubtasksAfterThis];
    NSArray *arrayOfSubtasksAfterThisTask = [currentOwnerTask.subTasks objectsAtIndexes:indexSetOfSubtasksAfterThis];
    
    for (Task *subtask in arrayOfSubtasksAfterThisTask) {
        [thisTask addSubtask:subtask atIndex:InsertTaskAtEnd];
    }
}

#pragma mark -
#pragma mark Manipulate TableView looks

-(void)removeTasksFromDSAndTBVWithRange:(NSRange)range andAnimation:(UITableViewRowAnimation)animation
{
    NSAssert1(NUMBER_OF_SECTIONS == 1, @"Fix number of sections!!", nil);
    
    //build array with IP for tableview
    NSMutableArray *arrayOfIndexPathsThatShouldBeRemoved = [[NSMutableArray alloc] init];
    NSUInteger section = NUMBER_OF_SECTIONS-1;
    NSUInteger row = range.location;
    for ( NSUInteger indexAdd = 0; indexAdd < range.length; indexAdd++) {
        NSIndexPath *ipForOneSubTask = [NSIndexPath indexPathForRow:row+indexAdd inSection:section];
        if (ipForOneSubTask.row >= [self.tasksForTableView count]) {
            NSLog(@"Ummmm...");
        }
        [arrayOfIndexPathsThatShouldBeRemoved addObject:ipForOneSubTask];
        NSLog(@"IP Sec:%d, Row: %d",ipForOneSubTask.section, ipForOneSubTask.row);
    }
    
    //remove the stuff from data source
    if (range.location + range.length > [self.tasksForTableView count]) {
        NSLog(@"DANGER DANGER trying to delete a row that DOES NOT EXIST! Why???");
    }
    [self.tasksForTableView removeObjectsInRange:range];
    
    //remove from tableview
    [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPathsThatShouldBeRemoved withRowAnimation:animation];
}



-(void)removeTasksAndAllItsSubtasksFromTableview:(Task*)taskToBeRemoved withAnimation:(UITableViewRowAnimation)rowAnimation
{
    NSUInteger indexOfTaskThatShouldBeRemoved = [self.tasksForTableView indexOfObject:taskToBeRemoved];
    
    NSIndexPath *iP = [NSIndexPath indexPathForRow:indexOfTaskThatShouldBeRemoved inSection:0];
    NSUInteger cellIndentation = [self indentationForCellAtIndexPath:iP];

    
    NSUInteger depthLeftOnScreen = self.depthToShow - cellIndentation;
    NSUInteger amountOfTasksOnScreen = [taskToBeRemoved getTotalAmountOfSubtasksWithinLevels:depthLeftOnScreen];
    NSRange rangeThatShouldBeRemoved = {indexOfTaskThatShouldBeRemoved, amountOfTasksOnScreen};
    
    [self.tableView beginUpdates];
    
    [self removeTasksFromDSAndTBVWithRange:rangeThatShouldBeRemoved andAnimation:rowAnimation];
    
    [self.tableView endUpdates];
}

-(void)investigateIfWeShouldInsertMoreSubtasksInTableview
{
    //if we are pushing tasks left, maybe we need to fill in more tasks from the right
    
    //1 get all subtasks of the right level
    //2 see if any of them are NOT member of the current table
    //3 if not, find out where to insert and insert.
    
    NSAssert1(NUMBER_OF_SECTIONS == 1, @"Sections be fuuuucked up!", nil);
    NSUInteger currentSection  = 0;
    
    NSMutableArray *tasksThatShouldBeInTable = [self.theHeadTask subTasksAtDepth:self.depthToShow];

    static NSUInteger newIndexForThisTask; //if the task is the first of a set of subtasks, add it after the parent. If it is not, add it using the indexOfTask, which is the previous task we just added. 
    NSMutableArray *arrayOfIndexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (Task* task in tasksThatShouldBeInTable) {
        if (![self.tasksForTableView containsObject:task]) {
            NSLog(@"%@",task.title);
            NSUInteger indexOfThisObjectInSubTaskSet = [task.ownerTask.subTasks indexOfObject:task];
            if (indexOfThisObjectInSubTaskSet == 0) {
                newIndexForThisTask = [self.tasksForTableView indexOfObject:task.ownerTask] + 1; //one after the parent
            } else {
                newIndexForThisTask++;
            }
            
            NSLog(@"count: %d",[self.tasksForTableView count]);
            [self.tasksForTableView insertObject:task atIndex:newIndexForThisTask];
            NSLog(@"count: %d",[self.tasksForTableView count]);    
            NSIndexPath *newIndexPathForThisTask = [NSIndexPath indexPathForRow:newIndexForThisTask inSection:currentSection];
            [arrayOfIndexPathsToInsert addObject:newIndexPathForThisTask];
        }
        
    }
    
    [self.tableView beginUpdates];
    
    if ([arrayOfIndexPathsToInsert count]) {
        [self.tableView insertRowsAtIndexPaths:arrayOfIndexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [self.tableView endUpdates];
}

-(void)removeCellsThatAreTooDeepLevelAfterTask:(Task *)task
{
    NSUInteger indexOfTaskThatShouldBeRemoved = [self.tasksForTableView indexOfObject:task];
    
    NSAssert1(NUMBER_OF_SECTIONS == 1, @"Fix number of sections!!", nil);
    NSIndexPath *indexPathForTask = [NSIndexPath indexPathForRow:indexOfTaskThatShouldBeRemoved inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathForTask];
    
    NSInteger currentIndentationLevel = cell.indentationLevel;
    currentIndentationLevel++; //since we are 0 index in the comparison
    NSUInteger indentationUntilOutsideBounds = self.depthToShow - currentIndentationLevel;

    NSMutableArray *subtasksUnderAffectedTask = [task.ownerTask subTasksAtDepth:indentationUntilOutsideBounds+1]; //we add one because we do ownertask. because of that, we also get our swipedTask.
    NSArray *reversedArrayOfTasksThatShouldBeRemoved = [[subtasksUnderAffectedTask reverseObjectEnumerator] allObjects];
    
    [self.tableView beginUpdates];
    
    for (Task *task in reversedArrayOfTasksThatShouldBeRemoved) {
        if (![self.tasksForTableView containsObject:task]) {
            continue;
        }
        NSUInteger indexOfTask = [self.tasksForTableView indexOfObject:task];
        NSRange rangeOfTask = {indexOfTask,1};
        NSLog(@"SUBTASKSUNDERAFFECTEDTASK: %@",task.title);
        [self removeTasksFromDSAndTBVWithRange:rangeOfTask andAnimation:UITableViewRowAnimationRight];
    }
    
    [self.tableView endUpdates];

}

-(void)changeObjectFrom:(NSIndexPath*)fromIP to:(NSIndexPath*)toIP
{
    NSAssert1(NUMBER_OF_SECTIONS == 1, @"Sections be fuuuucked up!", nil);
    
    NSUInteger fromRow = fromIP.row;
    NSUInteger toRow = toIP.row;
    
    //if we're moving something back and forth, don't do anything.
    if (fromRow == toRow) {
        return;
    }
    
    /*
     Cases
     add to absolute top 
     
     if taskabove is owner -> we are rearranging
     if taskabove has same owner && no visible subtasks -> we are rearranging      
     add to a task which has VISIBLE subtasks, no matter the ownertask
     add underneath a task which does not have subtasks
     
     */
    
    Task *taskThatIsChanging = [self.tasksForTableView objectAtIndex:fromIP.row];
    
    if (toRow == 0) {
        //add to absolute top. If we are at absolute top, we CANNOT get index of toRow-1 below, so we condition it out
        //this is an exception. If it's already a member, rearrange, otherwise insert.
        if ([self.theHeadTask.subTasks containsObject:taskThatIsChanging]) {
            [taskThatIsChanging shouldBeBelow:self.theHeadTask];
        } else {
            [self.theHeadTask addSubtask:taskThatIsChanging atIndex:InsertTaskAtBeginning];
        }
    } else {
        NSUInteger taskAboveIndex = toRow < fromRow ? toRow-1 : toRow; //different task depending on where we are coming from.
        Task *taskAbove = [self.tasksForTableView objectAtIndex:taskAboveIndex];
        NSUInteger visibleIndentationsLeftForTaskAbove = [self visibleDepthLeftForTaskAtIndexPath:toIP];
        NSArray *visibleSubtasksOfTaskAbove = [taskAbove getAllSubtasksWithinDepth:visibleIndentationsLeftForTaskAbove];
        NSLog(@"taskAbove.title: %@",taskAbove.title);

        
        if ([visibleSubtasksOfTaskAbove count]) {
            //the ownertask stays the same, we just want to change the current index.
            [taskThatIsChanging shouldBeAddedTo:taskAbove];
        } else 
            if (![visibleSubtasksOfTaskAbove count])
            {
                //if task above does NOT have visible subtasks and NOT the same owner, we want to add it to the same owner, after the task above
                [taskThatIsChanging shouldBeBelow:taskAbove];
            } else {
                NSAssert1(nil, @"Should never be here! logic error", nil);
            }
    
    }
    
    [self.managedObjectContext save:nil];
    
    NSUInteger visibleIndentationsLeft = [self visibleDepthLeftForTaskAtIndexPath:fromIP];
    NSMutableArray *objectsThatShouldBeMoved = [taskThatIsChanging getAllSubtasksWithinDepth:visibleIndentationsLeft];
    
    [objectsThatShouldBeMoved insertObject:taskThatIsChanging atIndex:0];
    [self moveObjectsInTableViewArray:objectsThatShouldBeMoved row:fromRow to:toRow];
    
    
    for (Task* task in self.tasksForTableView) {
        NSLog(@"Table after updates: %@",task.title);
    }
}

#pragma mark Different Data store manipulations from manual reordering
-(void)moveTaskToAbsoluteTop:(Task*)task
{
    
}



-(void)moveObjectsInTableViewArray:(NSArray*)objects row:(NSUInteger)fromRow to:(NSUInteger)toRow
{
    [self.tableView beginUpdates];
    
    for (NSUInteger extraIndex = 0; extraIndex < [objects count]; extraIndex++) {
        [self.tasksForTableView moveObjectFromIndex:fromRow+extraIndex toIndex:toRow+extraIndex];
    }
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


#pragma mark - 
#pragma mark Misc
-(NSUInteger)visibleDepthLeftForTaskAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger indentationForCell = [self indentationForCellAtIndexPath:indexPath];
    NSUInteger depthLeft = self.depthToShow - indentationForCell;
    return depthLeft;
}

-(NSUInteger)indentationForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSUInteger indentation = cell.indentationLevel;
    
    return indentation;
}



@end
