//
//  NSMutableArray+moveObject.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (moveObject)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
