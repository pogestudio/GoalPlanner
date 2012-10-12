//
//  FreeTimeContainer.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AvailableTimesContainer.h"
#import "PLAvailableTimeSlot.h"
#import "PLSchedule.h"

@interface AvailableTimesContainer()
@end

@implementation AvailableTimesContainer

@synthesize availableTimes;
@synthesize lastAccessedIndex;
@synthesize defaultCalendar = __defaultCalendar;

-(id)initWithAvailableTimes:(NSMutableArray*)times
{
    self = [super init];
    if (self) {
        self.lastAccessedIndex = 0; //make "givenext" give the first element the first time.
        self.availableTimes = times;
    }
    
    return self;
}

-(PLAvailableTimeSlot*)getNextSlotThatFitsSchedule:(PLSchedule*)schedule
{
    
    NSAssert1(self.availableTimes != nil, @"availabletimes is nil",nil);
    
    BOOL slotFitsSchedule = NO;
    PLAvailableTimeSlot *availableTime = nil;
    
    while (self.lastAccessedIndex < [self.availableTimes count]) {
        NSLog(@"lastAccessedIndex: %d\navailable times count: %d",self.lastAccessedIndex,[self.availableTimes count]);
        availableTime = [self.availableTimes objectAtIndex:self.lastAccessedIndex];
        if (availableTime.isScheduled) {
            //skip this one if it is already scheduled
            self.lastAccessedIndex++;
            continue;
        }
        
        availableTime.delegate = self;
        slotFitsSchedule = [availableTime moldSlotToFitSchedule:schedule];
        
        if (slotFitsSchedule) {
            availableTime.isScheduled = YES;

            return availableTime;
        } else {
            availableTime = nil;
            self.lastAccessedIndex++;
        }
        
    }
    
    return availableTime; //still nil if nothing found
}

#pragma mark AvailableTimeCreator
-(void)createNewTimeSlotFromDate:(NSDate*)startTime to:(NSDate*)endTime atPositionOf:(InsertAtPosition)pos of:(PLAvailableTimeSlot*)refSLot;
{
    NSLog(@"Array BEFORE INSERTION:%@\nWithRefSlot: %@",self.availableTimes,refSLot);

    //NSLog(@"EndTIme:%@",endTime);
    NSAssert1(startTime != nil && endTime != nil &&  startTime == [startTime earlierDate:endTime], @"logic wrong in arrray of new availabletimeslots", nil);
    NSAssert1(refSLot != nil, @"PLAVT is nil!!", nil);

    PLAvailableTimeSlot *newTime = [[PLAvailableTimeSlot alloc] initFromDate:startTime to:endTime];
    if (pos == InsertAtPositionAfter) {
        NSLog(@"\n-----\nREFSLOT Start: %@\nEnd: %@\n-----\nNewslot Start: %@\nEnd: %@",
              refSLot.startTime,
              refSLot.endTime,
              newTime.startTime,
              newTime.endTime);
    } else {
        NSLog(@"\n-----\nNEWSLOT Start: %@\nEnd: %@\n-----\nREFSLOT Start: %@\nEnd: %@",
              newTime.startTime,
              newTime.endTime,
              refSLot.startTime,
              refSLot.endTime);
    }
    NSUInteger indexOfReferenceSlot = [self.availableTimes indexOfObject:refSLot];
    NSUInteger indexOfNewSlot;
    switch (pos) {
        case InsertAtPositionBefore:
        {
            indexOfNewSlot = indexOfReferenceSlot;
            break;
        }
        case InsertAtPositionAfter:
        {
            indexOfNewSlot = indexOfReferenceSlot + 1;
            break;
        }
            
        default:
            NSAssert1(nil, @"Should never be here! wrong in createNewTImeSlot!!", nil);
            break;
    }
    [self.availableTimes insertObject:newTime atIndex:indexOfNewSlot];
    NSLog(@"Array AFTER INSERTION:%@",self.availableTimes);
}

#pragma mark OfferDefaultCalendar
-(NSCalendar*)defaultCalendar
{
    if (__defaultCalendar == nil) {
        __defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:@"gregorian"];
    }
    return __defaultCalendar;
}


@end