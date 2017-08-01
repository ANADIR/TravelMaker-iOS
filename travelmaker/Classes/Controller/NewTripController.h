//
//  NewTripController.h
//  Travel Maker
//
//  Created by developer on 12/11/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"

@protocol NewTripDelegate

- (void)gotoNewOfferTrip;
- (void)gotoNewRequestTrip;
- (void)closePopup;

@end

@interface NewTripController : SuperViewController

@property(nonatomic, assign) NSObject<NewTripDelegate> *delegate;

- (IBAction)clickNewOfferTrip:(id)sender;
- (IBAction)clickNewRequestTrip:(id)sender;
- (IBAction)clickClosePopup:(id)sender;

@end
