//
//  TrafficController.m
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "TrafficController.h"
#import "TrafficViewCell.h"
#import "RequestDetailController.h"
#import "OfferDetailController.h"
#import "UIViewController+MJPopupViewController.h"
#import "NewTripController.h"
#import "RegisterController.h"
#import "NewRequestController.h"
#import "NewOfferController.h"


@interface TrafficController ()
{
    BOOL isAscPassenger;
    BOOL isAscHour;
    BOOL isAscDate;
    BOOL isAscAreaOrDest;
    BOOL isAscStart;
    
    BOOL isOpenedMenu;
    BOOL isSelectedRequest;
}
@end

@implementation TrafficController

@synthesize btnRequest, btnOffer, btnAreaOrDest;
@synthesize lblRequest, lblOffer;
@synthesize tblTraffic;
@synthesize HeaderAreaWidth;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isAscPassenger = YES;
    isAscHour = YES;
    isAscDate = YES;
    isAscAreaOrDest = YES;
    isAscStart = YES;
    
    isOpenedMenu = NO;
    isSelectedRequest = YES;
    [self switchRequest:isSelectedRequest];
    
    self.arrayTrafficData = [[NSMutableArray alloc] init];
    self.arrayOfferTrip = [[NSMutableArray alloc] init];
    self.arrayRequestTrip = [[NSMutableArray alloc] init];
    
    //Pull to refresh table
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"טוען נתונים..."];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tblTraffic addSubview:refreshControl];
    
//    [self loadTrafficData];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self RefreshTrafficData];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    HeaderAreaWidth.constant = (SCREEN_WIDTH - 160 - 16) / 2.0f;
    [self updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadTrafficData];
}

- (void)switchRequest:(BOOL)isRequest
{
    if (isRequest)
    {
        [btnRequest setImage:[UIImage imageNamed:@"AvailableInEnable"] forState:UIControlStateNormal];
        [lblRequest setTextColor:[UIColor whiteColor]];
        
        [btnOffer setImage:[UIImage imageNamed:@"RideGiveDisable"] forState:UIControlStateNormal];
        [lblOffer setTextColor:[UIColor colorWithRed:150.0/255.0 green:185.0/255.0 blue:219.0/255.0 alpha:1.0]];
        
        [btnAreaOrDest setTitle:@"לאזור" forState:UIControlStateNormal];
    }
    else
    {
        [btnOffer setImage:[UIImage imageNamed:@"RideGiveEnable"] forState:UIControlStateNormal];
        [lblOffer setTextColor:[UIColor whiteColor]];
        
        [btnRequest setImage:[UIImage imageNamed:@"AvailableInDisable"] forState:UIControlStateNormal];
        [lblRequest setTextColor:[UIColor colorWithRed:150.0/255.0 green:185.0/255.0 blue:219.0/255.0 alpha:1.0]];
        
        [btnAreaOrDest setTitle:@"יעד" forState:UIControlStateNormal];
    }
}

- (void)loadTrafficData
{
    
    NSString * getTrafficUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getAllTrafficData";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:getTrafficUrl :^(NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSData *responseData = data;
        if (responseData == nil) {
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"result string: %@", string);

        NSError *error;
        self.arrayTrafficData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if (self.arrayTrafficData != nil)
        {
            [self.arrayOfferTrip removeAllObjects];
            [self.arrayRequestTrip removeAllObjects];

            for (id traffic in self.arrayTrafficData)
            {
                NSString *type = [traffic objectForKey:@"traffic_type"];
                if (type == (NSString *)[NSNull null])
                    continue;
                
                if ([type isEqualToString:@"requested"] == YES)
                    [self.arrayRequestTrip addObject:traffic];
                else
                    [self.arrayOfferTrip addObject:traffic];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblTraffic reloadData];
        });
    }];
}

- (void)RefreshTrafficData
{
    
    NSString * getTrafficUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getAllTrafficData";
    
    [DCDefines getHttpAsyncResponse:getTrafficUrl :^(NSData *data, NSError *connectionError) {
        
        NSData *responseData = data;
        if (responseData == nil) {
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"result string: %@", string);
        
        NSError *error;
        self.arrayTrafficData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if (self.arrayTrafficData != nil)
        {
            [self.arrayOfferTrip removeAllObjects];
            [self.arrayRequestTrip removeAllObjects];
            
            for (id traffic in self.arrayTrafficData)
            {
                NSString *type = [traffic objectForKey:@"traffic_type"];
                if (type == (NSString *)[NSNull null])
                    continue;
                
                if ([type isEqualToString:@"requested"] == YES)
                    [self.arrayRequestTrip addObject:traffic];
                else
                    [self.arrayOfferTrip addObject:traffic];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblTraffic reloadData];
        });
    }];
}



#pragma mark - IBAction

- (IBAction)clickMenu:(id)sender
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    if (user_id == nil)
    {
        [Common showAlert:@"תקלה" Message:@"אנא בצע רישום על מנת להמשיך" ButtonName:@"אשר"];
        return;
    }

    if (isOpenedMenu == NO)
    {
        [self.menuController setMenuState:MFSideMenuStateLeftMenuOpen completion:^{
            isOpenedMenu = YES;
        }];
    }
    else
    {
        [self.menuController setMenuState:MFSideMenuStateClosed completion:^{
            isOpenedMenu = NO;
        }];
    }
}

- (IBAction)clickAddNew:(id)sender
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    if (user_id == nil || [user_id isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"שים לב"
                                                         message:@"אינך רשום עדיין, האם ברצונך להרשם עכשיו?"
                                                        delegate:self
                                               cancelButtonTitle:@"לא"
                                               otherButtonTitles:@"כן", nil];
        [alert show];        
        return;
    }
    
    NewTripController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newTripVC"];
    controller.delegate = self;
    [controller.view setFrame:CGRectMake(0, 100, 320, 320)];
    [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
}

- (IBAction)clickRequest:(id)sender
{
    isSelectedRequest = YES;
    [self switchRequest:isSelectedRequest];
    
    [tblTraffic reloadData];
}

- (IBAction)clickOffer:(id)sender
{
    isSelectedRequest = NO;
    [self switchRequest:isSelectedRequest];
    
    [tblTraffic reloadData];
}


- (IBAction)clickPassenger:(id)sender
{
    if (isSelectedRequest == YES)
    {
        [self.arrayRequestTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"num_passengers"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"num_passengers"];
            
            if (isAscPassenger == YES)
                return [value1 compare:value2 options:NSNumericSearch];
            else
                return [value2 compare:value1 options:NSNumericSearch];
        }];
        
        [tblTraffic reloadData];
    }
    else
    {
        [self.arrayOfferTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"num_passengers"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"num_passengers"];

            if (isAscPassenger == YES)
                return [value1 compare:value2 options:NSNumericSearch];
            else
                return [value2 compare:value1 options:NSNumericSearch];

        }];
        
        [tblTraffic reloadData];
    }
    
    isAscPassenger = !isAscPassenger;
}

- (IBAction)clickHour:(id)sender;
{
    if (isSelectedRequest == YES)
    {
        [self.arrayRequestTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"time_start"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"time_start"];
            
            if (isAscHour == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    else
    {
        [self.arrayOfferTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"time_start"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"time_start"];

            if (isAscHour == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    
    isAscHour = !isAscHour;
}

- (IBAction)clickDate:(id)sender
{
    if (isSelectedRequest == YES)
    {
        [self.arrayRequestTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"date_start"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"date_start"];
            
            if (isAscDate == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    else
    {
        [self.arrayOfferTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"date_start"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"date_start"];
            
            if (isAscDate == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    
    isAscDate = !isAscDate;
}

- (IBAction)clickAreaOrDest:(id)sender
{
    if (isSelectedRequest == YES)
    {
        [self.arrayRequestTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"area"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"area"];
            
            if (isAscAreaOrDest == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    else
    {
        [self.arrayOfferTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"destination"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"destination"];

            if (isAscAreaOrDest == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    
    isAscAreaOrDest = !isAscAreaOrDest;
}

- (IBAction)clickStart:(id)sender
{
    if (isSelectedRequest == YES)
    {
        [self.arrayRequestTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"start_location"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"start_location"];
            
            if (isAscStart == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    else
    {
        [self.arrayOfferTrip sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *value1 = (NSString *)[obj1 objectForKey:@"start_location"];
            NSString *value2 = (NSString *)[obj2 objectForKey:@"start_location"];
            
            if (isAscStart == YES)
                return [value1 compare:value2];
            else
                return [value2 compare:value1];
        }];
        
        [tblTraffic reloadData];
    }
    
    isAscStart = !isAscStart;
}

#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSelectedRequest == YES)
        return [self.arrayRequestTrip count];
    else
        return [self.arrayOfferTrip count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrafficViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trafficCell"];
    
    if (cell == nil) {
        
        cell = [[TrafficViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"trafficCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *trafficData = nil;
    
    if (isSelectedRequest == YES)
    {
        trafficData = [self.arrayRequestTrip objectAtIndex:indexPath.row];
        [cell.lblAreaOrDest setText:[trafficData objectForKey:@"area"]];
    }
    else
    {
        trafficData = [self.arrayOfferTrip objectAtIndex:indexPath.row];
        [cell.lblAreaOrDest setText:[trafficData objectForKey:@"destination"]];
    }
    
    NSString *date = [trafficData objectForKey:@"date_start"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *displayDate = [dateFormatter stringFromDate:dateFromString];

    [cell.lblDate setText:displayDate];
    [cell.lblPassenger setText:[trafficData objectForKey:@"num_passengers"]];
    [cell.lblHour setText:[trafficData objectForKey:@"time_start"]];
    [cell.lblPlaceStart setText:[trafficData objectForKey:@"start_location"]];


    [cell.layer setCornerRadius:5.0f];
    [cell.layer setMasksToBounds:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSelectedRequest == YES)
    {
        NSDictionary *traffic = [self.arrayRequestTrip objectAtIndex:indexPath.row];
        
        RequestDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"requestDetailVC"];
        [controller setTrafficData:traffic];
        controller.trafficDelegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        NSDictionary *traffic = [self.arrayOfferTrip objectAtIndex:indexPath.row];
        
        OfferDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerDetailVC"];
        [controller setTrafficData:traffic];
        controller.trafficDelegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // cancel
    }
    else
    {
        // Ok
        RegisterController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - NewTripDelegate
- (void)gotoNewOfferTrip
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    NewOfferController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newOfferVC"];
    controller.trafficDelegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)gotoNewRequestTrip
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

    NewRequestController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newRequestVC"];
    controller.trafficDelegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)closePopup
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - TrafficDelegate
- (void)trafficDetailControllerDismissed:(BOOL)isShowRequest
{
    isSelectedRequest = isShowRequest;
    [self switchRequest:isSelectedRequest];

//    [self loadTrafficData];
}

@end
