//
//  MyMessageDetailController.h
//  Travel Maker
//
//  Created by developer on 1/10/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"

@interface MyMessageDetailController : SuperViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSDictionary *trafficData;

@property (nonatomic, weak) IBOutlet UITableView *tblTraffic;
@property (nonatomic, weak) IBOutlet UILabel *lblTrip;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription;

@property (nonatomic, weak) IBOutlet UIView *vwCompany;
@property (nonatomic, weak) IBOutlet UILabel *lblCompany;

- (IBAction)clickBack:(id)sender;

@end
