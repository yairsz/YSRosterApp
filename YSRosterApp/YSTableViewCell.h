//
//  YSTableViewCell.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/17/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPerson.h"

@interface YSTableViewCell : UITableViewCell

@property (weak,nonatomic) YSPerson * person;

@end
