//
//  NSDateComponents+Compare.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDateComponents+Compare.h"



@implementation NSDateComponents (Compare)

-(BOOL)isEarlierInWeekThan:(NSDateComponents *)otherComp
{
    BOOL thisIsEarlier;
    
    //corner case if we're checking a saturday against a monday

    
    
    if ([self weekday] < [otherComp weekday]) {
        thisIsEarlier =  YES;
    } else if([self weekday] > [otherComp weekday]) {
        thisIsEarlier = NO;
    } else if([self hour] < [otherComp hour]) {
        thisIsEarlier = YES;
    } else if([self hour] > [otherComp hour]) {
        thisIsEarlier = NO;
    } else if([self minute] < [otherComp minute]) {
        thisIsEarlier = YES;
    } else if([self minute] > [otherComp minute]) {
        thisIsEarlier = NO;
    } else {
        thisIsEarlier = YES;
    }
    
    return thisIsEarlier;
}

-(NSInteger)secondsUntil:(NSDateComponents *)otherComp
{
    NSUInteger secondsOfThis = [self secondsInThisDay];
    NSUInteger secondsOfOther = [otherComp secondsInThisDay];
    NSInteger difference = secondsOfOther - secondsOfThis;
    return difference;
    
}

-(NSDateComponents*)getEarliest:(NSDateComponents *)comp1
{
    if ([self isEarlierInWeekThan:comp1]) {
        return [self copy];
    } else {
        return [comp1 copy];
    }
    
}

-(NSDateComponents*)getLatest:(NSDateComponents *)comp1
{
    if (![self isEarlierInWeekThan:comp1]) {
        return [self copy];
    } else {
        return [comp1 copy];
    }
    
}

-(NSUInteger)secondsInThisDay
{
    NSUInteger seconds = ([self hour]*60 + [self minute])*60;
    return seconds;
}

-(void)printInfoAfterString:(NSString *)preText
{
    NSLog(@"DEBUG::%@- Weekday: %d Hour: %02d:%02d",preText,[self weekday], [self hour], [self minute]);
}

-(CornerCase)isCornerCaseOfComparisonTowards:(NSDateComponents *)otherComp
{
    //corner case for comparison.
    //if we're comparing times over the end/start of a week we can't go with regular weekday comparison
    NSUInteger saturday = 7;
    NSUInteger sunday = 1;
    
    BOOL regularCornerCase = [self weekday] == saturday && [otherComp weekday] == sunday;
    BOOL cornerCaseReverse = [self weekday] == sunday && [otherComp weekday] == saturday;
    
    CornerCase currentComparison;
    if (regularCornerCase) {
        currentComparison = CornerCaseExist;
    } else if (cornerCaseReverse) {
        currentComparison = CornerCaseReverse;
    } else {
        currentComparison = CornerCaseNone;
    }
    
    return currentComparison;
}

-(void)modifyToNotBeLongerFrom:(NSDateComponents *)earlierComponent than:(CGFloat)hours
{

    NSUInteger secondsBetween = [earlierComponent secondsUntil:self];
    CGFloat hoursBetween = secondsBetween / SECONDS_PER_HOUR;
    if (hoursBetween > hours) {
        [self printInfoAfterString:@"component before mod!"];
        CGFloat difference = hoursBetween-hours;
        NSUInteger numberOfHoursThatShouldBeRemoved = ((NSUInteger)difference)/1;
        NSUInteger numberOfMinutesThatShouldBeRemoved = fmodf(difference, 1.0) * 60;
        if (numberOfMinutesThatShouldBeRemoved > self.minute) {
            numberOfHoursThatShouldBeRemoved++;
            self.minute = 60 - (numberOfMinutesThatShouldBeRemoved - self.minute);
        } else {
            self.minute = self.minute - numberOfMinutesThatShouldBeRemoved;
        }
        self.hour = self.hour - numberOfHoursThatShouldBeRemoved;
        [self printInfoAfterString:@"component after mod!"];
    }
}



@end
