//
//  TitleCell.h
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UITextField *title;
@property (strong, nonatomic) IBOutlet UIView *isComplete;

@end
