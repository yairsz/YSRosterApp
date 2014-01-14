//
//  YSTableViewDataSource.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSTableViewDataSource.h"
#import "YSPerson.h"


@implementation YSTableViewDataSource

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView {
    
    if (self = [super init]) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }
    
    return self;
}

- (NSMutableArray *) studentsArray
{
    if (!_studentsArray) {
        _studentsArray = [[NSMutableArray alloc] init];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        
        NSLog(@" %@", array);
        
        
        for (NSDictionary * personData in array) {
            if ([personData[@"role"] isEqualToString:@"Student"]) {
            
                YSPerson * person = [[YSPerson alloc] initWithRole:personData[@"role"] andName:personData[@"name"]];
                
                [_studentsArray addObject:person];
            }
        }
    }
    return _studentsArray;
}

- (NSMutableArray *) teachersArray
{
    if (!_teachersArray) {
        _teachersArray = [[NSMutableArray alloc] init];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        
        
        for (NSDictionary * personData in array) {
            if ([personData[@"role"] isEqualToString:@"Teacher"]) {
                YSPerson * person = [[YSPerson alloc] initWithRole:personData[@"role"] andName:personData[@"name"]];
                [_teachersArray addObject:person];
            }
        }
    }
    return _teachersArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"STUDENTS";
            break;
        case 1:
            return @"TEACHERS";
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.studentsArray.count;
            break;
        case 1:
            return self.teachersArray.count;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"aCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 1:
            cell.textLabel.text = [[[self teachersArray] objectAtIndex:indexPath.row] name];
            return cell;
        default:
            cell.textLabel.text = [[[self studentsArray] objectAtIndex:indexPath.row] name];
            return cell;
    }
}



@end
