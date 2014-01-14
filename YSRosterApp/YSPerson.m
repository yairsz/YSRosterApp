//
//  YSStudent.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/14/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSPerson.h"

@implementation YSPerson


- (YSPerson *) initWithRole:(NSString *) role andName: (NSString *) name;
{
    if (self = [super init]) {
        _role = role;
        _name = name;
    }
    return self;
}
@end
