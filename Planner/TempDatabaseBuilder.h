//
//  TempDatabaseBuilder.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class Schedule;

@interface TempDatabaseBuilder : NSObject

-(void)insertTestStuff;

@property (nonatomic, retain) NSManagedObjectContext *moc;



@end
