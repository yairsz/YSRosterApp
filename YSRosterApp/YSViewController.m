//
//  YSViewController.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewController.h"
#import "YSScrollViewController.h"
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
    self.dataSource = [YSTableViewDataSource sharedDataSource];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    
    //this sets up the refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.title = @"iOS B9";
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openEmail)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This determines which cells will go to the teachers section and which ones to the students section
    NSString * matchString = indexPath.section == 0 ? @"Student" : @"Teacher";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"role MATCHES %@", matchString];
    NSArray * filteredArray = [self.dataSource.personsArray filteredArrayUsingPredicate:predicate];
    self.selectedPerson = [filteredArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"tableToPerson" sender:self];
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YSScrollViewController * detailController = segue.destinationViewController;
    detailController.selectedPerson = self.selectedPerson;
    detailController.dataSource = self.dataSource;
    
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

-(void) openEmail {
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        
        NSMutableString * messageBody = [[NSMutableString alloc] init];
        [messageBody appendString:@"\n\n-------------Code Fellows 01/13 iOS Bootcamp Roster-------------\n\n"];
        for (YSPerson * person in self.dataSource.personsArray) {
            if (person.imagePath){
                NSData * imageData = [NSData dataWithContentsOfFile:person.imagePath];
                NSString * imageFileName = [NSString stringWithFormat:@"%@.jpg",person.name];
                [mailComposer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:imageFileName];
            }
            [messageBody appendString:@"\n"];
            [messageBody appendString:person.name];
            [messageBody appendString:@"\n"];
            [messageBody appendString:person.role];
            [messageBody appendString:@"\n"];
            [messageBody appendString:@"Twitter:"];
            if (person.twitter) [messageBody appendString:person.twitter];
            [messageBody appendString:@"\n"];
            [messageBody appendString:@"Github:"];
            if (person.github) [messageBody appendString:person.github];
            [messageBody appendString:@"\n"];
            [messageBody appendString:@"\n"];
            
            
        }
        
        
        [mailComposer setSubject:@"Code Fellows 01/13 iOS Bootcamp Roster"];
        [mailComposer setMessageBody:messageBody isHTML:NO];
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}


//Dismiss MFMail


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Message failed to Send"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MFMailComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MFMailComposeResultSaved) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                        message:@"Message was saved to your drafts folder"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"The Roster was sent to your email address."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



- (NSString *) applicationDocumentsDirectory
{
    NSURL * docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [docsURL path];
}


@end
