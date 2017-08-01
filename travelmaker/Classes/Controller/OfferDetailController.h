//
//  OfferDetailController.h
//  Travel Maker
//
//  Created by developer on 12/10/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "NewTripController.h"
#import "TrafficController.h"
#import <MessageUI/MessageUI.h>

@interface OfferDetailController : SuperViewController <UITableViewDataSource, UITableViewDelegate, NewTripDelegate, MFMessageComposeViewControllerDelegate>
{
    NSString *cellphone;
}

@property (nonatomic, assign) id<TrafficDelegate> trafficDelegate;

@property (copy, nonatomic) NSDictionary *trafficData;

@property (nonatomic, weak) IBOutlet UITableView *tblTraffic;
@property (nonatomic, weak) IBOutlet UILabel *lblTrip;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;


@property (nonatomic, weak) IBOutlet UIView *vwCompany;
@property (nonatomic, weak) IBOutlet UILabel *lblCompany;

@property (nonatomic, weak) IBOutlet UIView *vwWhatsapp;
@property (nonatomic, weak) IBOutlet UIView *vwTelephone;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickAddNew:(id)sender;
- (IBAction)clickOffer:(id)sender;
- (IBAction)clickRequest:(id)sender;

- (IBAction)clickWhatsapp:(id)sender;
- (IBAction)clickTelephone:(id)sender;
- (IBAction)clickClose:(id)sender;

@end
