//
//  NewTripController.m
//  Travel Maker
//
//  Created by developer on 12/11/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "NewTripController.h"

@implementation NewTripController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction
- (IBAction)clickNewOfferTrip:(id)sender
{
    [self.delegate gotoNewOfferTrip];
}

- (IBAction)clickNewRequestTrip:(id)sender
{
    [self.delegate gotoNewRequestTrip];
}

- (IBAction)clickClosePopup:(id)sender
{
    [self.delegate closePopup];
}


@end
