//
//  YSTableViewDataSource.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSTableViewDataSource.h"
#import "YSPerson.h"
#define STORE_FILE_NAME @"personsStore"


@interface YSTableViewDataSource()
@property (nonatomic) NSArray * plistDataArray;

@end

@implementation YSTableViewDataSource

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView {
    
    if (self = [super init]) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }

    return self;
}

- (NSArray * ) plistDataArray {
    
    //This setter method checks for presence of the database at path if it doesn't exist it will read from the plist file
    
    NSString * fullPath = [NSString pathWithComponents:@[[[self applicationDocumentsDirectory] path], STORE_FILE_NAME]];
                           
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
        _plistDataArray = [NSArray arrayWithContentsOfFile:path];
        [NSKeyedArchiver archiveRootObject:_plistDataArray toFile:fullPath];
    } else {
        _plistDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    }
    
    
    return _plistDataArray;
}


- (NSMutableArray *) studentsArray
{
    //Lazy instatiation of the students array
    
    if (!_studentsArray) {
        _studentsArray = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary * personData in self.plistDataArray) {
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
    //Lazy instatiation of the teachers array

    if (!_teachersArray) {
        _teachersArray = [[NSMutableArray alloc] init];
        
        
        
        for (NSDictionary * personData in self.plistDataArray) {
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
    // The first Section in the tableview is the teachers and the second is the students
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
    // the number of rows in each section depends on the number of persons
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


- (void) sortTableViewWithSortDescriptor:(NSSortDescriptor *) sortDescriptor
{
    //this method receives a sort descriptor and re-sorts the arrays
    
    self.studentsArray = (NSMutableArray *)[self.studentsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.teachersArray = (NSMutableArray *)[self.teachersArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}

- (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
    
@end
