//
//  YSTableViewDataSource.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTableViewDataSource : NSObject <UITableViewDataSource>

// This class removes the Data source protocol from the UIViewController to enforce the MVC design Pattern. This would be the Model part of it.

@property (nonatomic) NSMutableArray * studentsArray;
@property (nonatomic) NSMutableArray * teachersArray;
@property (weak, nonatomic) UITableView * tableView;

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView;
- (void) sortTableViewWithSortDescriptor:(NSSortDescriptor *) sortDescriptor;

@end
