//
//  YSTableViewCell.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/17/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSTableViewCell.h"

@implementation YSTableViewCell

- (void) setPerson:(YSPerson *)person
{
        self.textLabel.text = person.name;
        
        //Add image to cell, if no ath is set will get set to nil
        UIImage * image = [UIImage imageWithContentsOfFile:person.imagePath];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.accessoryView = imageView;
        
        //Circular bounds for person image
        [imageView setBounds:CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, 40, 40)];
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
        imageView.clipsToBounds = YES;
        
        //Color of Row
        CGFloat red = [(NSNumber *)person.rgbValues[0] floatValue];
        CGFloat green = [(NSNumber *)person.rgbValues[1] floatValue];
        CGFloat blue = [(NSNumber *)person.rgbValues[2] floatValue];
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        self.textLabel.textColor = [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1];
}

@end
