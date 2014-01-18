//
//  YSViewController.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTableViewDataSource.h"
#import "YSPerson.h"
#import <MessageUI/MessageUI.h>

@interface YSViewController : UIViewController <UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) YSPerson * selectedPerson;
@property (weak, nonatomic) YSTableViewDataSource * dataSource;

- (void) openEmail;



@end
