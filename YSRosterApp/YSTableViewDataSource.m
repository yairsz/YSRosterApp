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

@end

@implementation YSTableViewDataSource

- (YSTableViewDataSource *) initWithTableView: (UITableView *) tableView {
    
    if (self = [super init]) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }

    return self;
}





- (NSMutableArray *) personsArray
{
    //This setter method checks for presence of the database at path. If it doesn't exist it will read from the plist file.
    
    if (!_personsArray) {
        
        _personsArray = [[NSMutableArray alloc] init]; //initialize the array
        
        BOOL isDir;
        NSArray * plistDataArray;
        
        //Check existance of the persons array at the store path, read data from plist if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathToStore] isDirectory:&isDir]) {
            NSString* path = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
            plistDataArray = [NSArray arrayWithContentsOfFile:path];
            for (NSDictionary * personData in plistDataArray) {
                YSPerson * person = [[YSPerson alloc] initWithRole:personData[@"role"] andName:personData[@"name"]];
                [_personsArray addObject:person];
            }
            //The firs time this data is initialized, the array must be directly archived because the property hasn't been set yet.
            [NSKeyedArchiver archiveRootObject:_personsArray toFile:[self pathToStore]];
            
        } else {
            _personsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathToStore]];
        }
    }
    
    return _personsArray;
}

- (void) saveData
{
    [NSKeyedArchiver archiveRootObject:self.personsArray toFile:[self pathToStore]];
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


- (NSInteger)numberOfStudents
{
    NSInteger studentCount = 0;
    for (YSPerson * person  in self.personsArray) {
        if ([person.role isEqualToString:@"Student"]) {
            studentCount ++;
        }
    }
    return studentCount;
    
}

- (NSInteger)numberOfTeachers
{
    NSInteger teacherCount = 0;
    for (YSPerson * person  in self.personsArray) {
        if ([person.role isEqualToString:@"Teacher"]) {
            teacherCount ++;
        }
    }
    return teacherCount;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // the number of rows in each section depends on the number of persons
    switch (section) {
        case 0:
            return [self numberOfStudents];
        case 1:
            return [self numberOfTeachers];
        default:
            return 0;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Figure out if section is student or teacher
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"aCell" forIndexPath:indexPath];
    NSString * matchString = indexPath.section == 0 ? @"Student" : @"Teacher";
    
    //setup an NSPredicate and filter the persons array
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"role MATCHES %@", matchString];
    NSArray * filteredArray = [self.personsArray filteredArrayUsingPredicate:predicate];
    
    //get person for indexpath in filtered array and set the cell label
    YSPerson * personForCell = [filteredArray objectAtIndex:indexPath.row];
    cell.textLabel.text = personForCell.name;
    
    //Add image to cell, if no ath is set will get set to nil
    UIImage * image = [UIImage imageWithContentsOfFile:personForCell.imagePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    cell.accessoryView = imageView;
    
    //Circular bounds for person image
    [imageView setBounds:CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, 40, 40)];
    imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
    imageView.clipsToBounds = YES;
    
    //Color of Row
    CGFloat red = [(NSNumber *)personForCell.rgbValues[0] floatValue];
    CGFloat green = [(NSNumber *)personForCell.rgbValues[1] floatValue];
    CGFloat blue = [(NSNumber *)personForCell.rgbValues[2] floatValue];
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1];
    
    return cell;
}


- (void) sortTableViewWithSortDescriptor:(NSSortDescriptor *) sortDescriptor
{
    //this method receives a sort descriptor and re-sorts the arrays
    
    self.personsArray = (NSMutableArray *)[self.personsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}

- (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
     
- (NSString *) pathToStore
{
    //First, get the full path to the persons store
    NSString * fullPath = [NSString pathWithComponents:@[[[self applicationDocumentsDirectory] path], STORE_FILE_NAME]];
    return fullPath;
}

@end
