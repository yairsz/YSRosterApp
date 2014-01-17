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
        _rgbValues = @[@1.f,@1.f,@1.f];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *) decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.role = [decoder decodeObjectForKey:@"role"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.twitter = [decoder decodeObjectForKey:@"twitter"];
    self.github = [decoder decodeObjectForKey:@"github"];
    self.imagePath = [decoder decodeObjectForKey:@"imagePath"];
    self.rgbValues = [decoder decodeObjectForKey:@"rgbValues"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.twitter forKey:@"twitter"];
    [encoder encodeObject:self.github forKey:@"github"];
    [encoder encodeObject:self.imagePath forKey:@"imagePath"];
    [encoder encodeObject:self.rgbValues forKey:@"rgbValues"];
}

@end
