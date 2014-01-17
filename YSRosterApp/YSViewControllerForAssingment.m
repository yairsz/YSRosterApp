//
//  YSViewControllerForAssingment.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/16/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewControllerForAssingment.h"

@interface YSViewControllerForAssingment ()

@end

@implementation YSViewControllerForAssingment

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"View Did Load");
}

-(void) viewWillLayoutSubviews
{
    NSLog(@"View Will Layout Subviews");
}

-(void) viewDidLayoutSubviews
{
    NSLog(@"View Did Layout Subviews");
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"View Will Appear");
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View Did Appear");
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"View Will Disappear");
};

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"View Did Disappear");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
