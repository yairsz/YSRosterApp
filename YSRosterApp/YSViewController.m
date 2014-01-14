//
//  YSViewController.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewController.h"
#import "YSDetailViewController.h"
#import "YSTableViewDataSource.h"
#import <CoreMotion/CoreMotion.h>

@interface YSViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL lastSort;

@end

@implementation YSViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.dataSource = [[YSTableViewDataSource alloc] initWithTableView:self.tableView];
    
    //this sets up the refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.title = @"Shake to sort";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change the arrays properties in this controller to be later used on the destination view controller
    switch (indexPath.section) {
        case 1:
            self.selectedPerson = [self.dataSource.teachersArray objectAtIndex:indexPath.row];
            break;
        default:
            self.selectedPerson = [self.dataSource.studentsArray  objectAtIndex:indexPath.row];
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



#pragma - mark Shake Gesture

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        //The sort decriptor is created in the view controller to be able to remember what was the last sort order. This is User dpendent and the data model should not concern itslef with it.
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:!self.lastSort];
        [self.dataSource sortTableViewWithSortDescriptor:sortDescriptor];
        self.lastSort = !self.lastSort;
        
    }
}







@end
