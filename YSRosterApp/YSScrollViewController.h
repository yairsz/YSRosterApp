//
//  YSDetailViewController.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPerson.h"
#import "YSTableViewDataSource.h"


@interface YSScrollViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) YSPerson * selectedPerson;
@property (weak, nonatomic) YSTableViewDataSource * dataSource;

@end
