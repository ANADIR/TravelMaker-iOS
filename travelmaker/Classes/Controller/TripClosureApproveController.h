//
//  TripClosureApproveController.h
//  Travel Maker
//
//  Created by developer on 1/4/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"

@interface TripClosureApproveController : SuperViewController

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;

@property (nonatomic) NSString *strTitle;
@property (nonatomic) NSString *strMessage;
@property (nonatomic) NSString *strTripId;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickApprove:(id)sender;

@end
