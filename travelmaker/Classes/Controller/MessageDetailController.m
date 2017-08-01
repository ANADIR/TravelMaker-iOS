//
//  MessageDetailController.m
//  Travel Maker
//
//  Created by developer on 1/4/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "MessageDetailController.h"

@implementation MessageDetailController

@synthesize lblMessage, lblTitle;
@synthesize strMessage, strTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [lblMessage setText:strMessage];
    [lblTitle setText:strTitle];
}
@end
