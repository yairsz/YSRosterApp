//
//  YSTableViewDataSource.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSMutableArray * studentsArray;
@property (nonatomic) NSMutableArray * teachersArray;
@property (weak, nonatomic) UITableView * tableView;

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView;

@end
