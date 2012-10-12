//
//  NSDate+Compare.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

@end