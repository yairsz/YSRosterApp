//
//  YSViewController.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewController.h"
#import "YSDetailViewController.h"

@interface YSViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * studentsArray;
@property (strong, nonatomic) NSArray * teachersArray;

@end

@implementation YSViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];

    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Instantiation

- (NSArray *) studentsArray
{
    if (!_studentsArray) {
        _studentsArray = @[@"Nicholas Barnard",
                           @"Zuri Biringer",
                           @"Chad Colby",
                           @"Spencer Fornaciari",
                           @"Raghav Haran",
                           @"Timothy Hise",
                           @"Ivan Lesko",
                           @"Richard Lichkus",
                           @"Bennett Lin",
                           @"Christopher Meehan",
                           @"Matt Remick",
                           @"Andrew Rodgers",
                           @"Jeff Schwab",
                           @"Steven Stevenson",
                           @"Yair Szarf"];
    }
    return _studentsArray;
}

- (NSArray *) teachersArray
{
    if (!_teachersArray) {
        _teachersArray = @[@"John Clem",
                           @"Brad Johnson",
                           @"Ivan Storck"];
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
            cell.textLabel.text = [[self teachersArray] objectAtIndex:indexPath.row];
            return cell;
        default:
            cell.textLabel.text = [[self studentsArray] objectAtIndex:indexPath.row];
            return cell;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            self.selectedPerson = [[self teachersArray] objectAtIndex:indexPath.row];
            break;
        default:
            self.selectedPerson = [[self studentsArray] objectAtIndex:indexPath.row];
            break;
    }
    [self performSegueWithIdentifier:@"tableToPerson" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YSDetailViewController * detailController = segue.destinationViewController;
    detailController.selectedPerson = self.selectedPerson;
    
}


- (void) refreshTableView: (UIRefreshControl *) refreshControl
{
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Refreshing"]];
    [refreshControl endRefreshing];
    
}













@end
