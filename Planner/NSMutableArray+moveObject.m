//
//  NSMutableArray+moveObject.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+moveObject.h"

@implementation NSMutableArray (moveObject)


- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}
@end
