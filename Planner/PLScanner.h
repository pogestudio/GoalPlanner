//
//  PLScanner.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLScanner : NSObject

@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

-(NSArray*)getEventsInCalendars:(NSArray*)calendars fromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

-(id)initFromDate:(NSDate *)sDate to:(NSDate *)eDate;
@end
