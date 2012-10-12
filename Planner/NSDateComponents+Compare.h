//
//  NSDateComponents+Compare.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface NSDateComponents (Compare)

typedef enum {
    CornerCaseNone,
    CornerCaseExist,
    CornerCaseReverse,
} CornerCase;

-(BOOL)isEarlierInWeekThan:(NSDateComponents*)otherComp;
-(NSInteger)secondsUntil:(NSDateComponents*)otherComp;
-(NSUInteger)secondsInThisDay;
-(void)printInfoAfterString:(NSString*)preText;
-(NSDateComponents*)getEarliest:(NSDateComponents*)comp1;
-(NSDateComponents*)getLatest:(NSDateComponents*)comp1;
-(CornerCase)isCornerCaseOfComparisonTowards:(NSDateComponents*)otherComp;

-(void)modifyToNotBeLongerFrom:(NSDateComponents*)component than:(CGFloat)hours;

@end
