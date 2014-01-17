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

// TODO: Change this class into a singleton that gets loaded from AppDelegate

//Changed the two arrays for students and teachers from last version and made it so there is only one persons array

@property (nonatomic) NSMutableArray * personsArray;

@property (weak, nonatomic) UITableView * tableView;

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView;
- (void) sortTableViewWithSortDescriptor:(NSSortDescriptor *) sortDescriptor;
- (void) saveData;

@end
