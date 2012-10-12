//
//  PLScanner.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLScanner.h"
#import "Schedule.h"

@implementation PLScanner

@synthesize eventStore;
@synthesize dateFormatter = __dateFormatter;

-(id)initFromDate:(NSDate *)sDate to:(NSDate *)eDate
{
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark scan task
-(NSArray*)getEventsInCalendars:(NSArray*)calendars fromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    
    NSPredicate *predicateForAllEvents = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
    NSArray *eventsForPred = [self.eventStore eventsMatchingPredicate:predicateForAllEvents];
    
   //FOR DEBUG PURPOSES
     for (EKEvent *event in eventsForPred) {
       NSLog(@"Title: %@\nStart: %@\nEnd: %@",
              event.title,
              [self.dateFormatter stringFromDate:event.startDate],
              [self.dateFormatter stringFromDate:event.endDate]);
   }
     
    
    return eventsForPred;
}




@end
