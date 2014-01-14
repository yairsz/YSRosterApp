//
//  YSStudent.h
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSPerson : NSObject

@property (nonatomic) NSString * role;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * twitter;
@property (nonatomic) NSString * github;

- (YSPerson *) initWithRole:(NSString *) role andName: (NSString *) name;


@end
