//
//  PLPLanner.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/*
 
 This baby is the one that manages which objects scans, plans etc.
 The only interface that the VC controlling the implementation of the goal will need
 
 */

#import <Foundation/Foundation.h>

@class Task;
@class PLOfTasks;

@interface PLPLanner : NSObject

@property (strong, nonatomic) NSArray *calendarsToScan;
@property (retain, nonatomic) Task *theGoal;
@property (retain, nonatomic) PLOfTasks *theHeadPlanner;


-(NSArray*)scanAndPlan;

@end
