//
//  YSAppDelegate.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTableViewDataSource.h"

@interface YSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YSTableViewDataSource * sharedDataSource;


@end
