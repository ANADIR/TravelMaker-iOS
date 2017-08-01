//
//  TrafficController.h
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "MFSideMenu.h"
#import "NewTripController.h"

@protocol TrafficDelegate <NSObject>

- (void)trafficDetailControllerDismissed:(BOOL)isShowRequest;

@end

@interface TrafficController : SuperViewController <UITableViewDataSource, UITableViewDelegate, NewTripDelegate, TrafficDelegate>

@property (assign, atomic) MFSideMenuContainerViewController *menuController;

@property (nonatomic, weak) IBOutlet UIButton *btnOffer;
@property (nonatomic, weak) IBOutlet UIButton *btnRequest;
@property (nonatomic, weak) IBOutlet UILabel *lblOffer;
@property (nonatomic, weak) IBOutlet UILabel *lblRequest;

@property (nonatomic, weak) IBOutlet UIButton *btnAreaOrDest;

@property (nonatomic, weak) IBOutlet UITableView *tblTraffic;


@property (strong, nonatomic) NSMutableArray *arrayTrafficData;
@property (strong, nonatomic) NSMutableArray *arrayOfferTrip;
@property (strong, nonatomic) NSMutableArray *arrayRequestTrip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeaderAreaWidth;


- (IBAction)clickMenu:(id)sender;
- (IBAction)clickAddNew:(id)sender;
- (IBAction)clickOffer:(id)sender;
- (IBAction)clickRequest:(id)sender;

- (IBAction)clickPassenger:(id)sender;
- (IBAction)clickHour:(id)sender;
- (IBAction)clickDate:(id)sender;
- (IBAction)clickAreaOrDest:(id)sender;
- (IBAction)clickStart:(id)sender;

@end
