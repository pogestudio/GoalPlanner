//
//  TaskCell.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;
@class TaskHandler;

@protocol TaskCellDelegate <NSObject>

-(void)layoutSubviewsForAllVisibleCellsInTableviewWithAnimation:(BOOL)animated;

@end


@interface TaskCell : UITableViewCell

-(void)setUpcellWithTask:(Task*)task andParentTask:(Task*)parentTask;
-(void)indentToRightLevelsWithAnimation:(BOOL)animation;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subLabel;
@property (nonatomic, retain) id <TaskCellDelegate>taskDelegate;
@property (nonatomic, retain) TaskHandler* taskHandler;
@property (nonatomic, retain) Task *taskForCell;
@property (nonatomic) NSUInteger tableIndentation;


@end
