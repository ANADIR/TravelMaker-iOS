//
//  OfferDetailController.m
//  Travel Maker
//
//  Created by developer on 12/10/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "OfferDetailController.h"
#import "DetailViewCell.h"
#import <DYRateView.h>
#import "UIViewController+MJPopupViewController.h"
#import "NewTripController.h"
#import "RegisterController.h"
#import "NewRequestController.h"
#import "NewOfferController.h"

@implementation OfferDetailController

@synthesize trafficData;
@synthesize lblDescription, lblTrip, lblCompany, lblTitle, lblPrice;
@synthesize tblTraffic;
@synthesize vwCompany, vwTelephone, vwWhatsapp;
@synthesize trafficDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *start_location = [trafficData objectForKey:@"start_location"];
    NSString *exit_location = [trafficData objectForKey:@"destination"];
    NSString *txtTrip = [NSString stringWithFormat:@"%@ - %@", exit_location, start_location];
    [lblTrip setText:txtTrip];
    [lblTitle setText:txtTrip];

    
    id freeText = [trafficData objectForKey:@"free_text"];
    NSString *txtFreeText = @"";
    if (freeText != [NSNull null])
        txtFreeText = (NSString *)freeText;
    [lblDescription setText:txtFreeText];
    
    NSString *txtCompany = [trafficData objectForKey:@"fullname"];
    [lblCompany setText:txtCompany];
    
    NSString *txtRate = [trafficData objectForKey:@"avg_rank"];
    float rateValue = 0.0f;
    if (txtRate == nil || [txtRate isEqualToString:@""] == YES)
        rateValue = 0.0f;
    else
        rateValue = [txtRate floatValue];
    
    CGRect frame = lblCompany.frame;
    CGRect rateFrame = CGRectMake(frame.origin.x, frame.origin.y + 30, frame.size.width, 30);
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:rateFrame];
    [rateView setRate:rateValue];
    [rateView setAlignment:RateViewAlignmentLeft];
    [vwCompany addSubview:rateView];
    
    UITapGestureRecognizer *tapWhatsapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapWhatsapp:)];
    [vwWhatsapp addGestureRecognizer:tapWhatsapp];
    
    UITapGestureRecognizer *tapTelephone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTelephone:)];
    [vwTelephone addGestureRecognizer:tapTelephone];
    
    [lblPrice setText:[trafficData objectForKey:@"price"]];
    
    cellphone = [trafficData objectForKey:@"cellphone"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)clickBack:(id)sender
{
    if ([self.trafficDelegate respondsToSelector:@selector(trafficDetailControllerDismissed:)])
    {
        [self.trafficDelegate trafficDetailControllerDismissed:NO];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([self.trafficDelegate respondsToSelector:@selector(trafficDetailControllerDismissed:)])
    {
        [self.trafficDelegate trafficDetailControllerDismissed:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOffer:(id)sender
{
    if ([self.trafficDelegate respondsToSelector:@selector(trafficDetailControllerDismissed:)])
    {
        [self.trafficDelegate trafficDetailControllerDismissed:NO];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickClose:(id)sender
{
    NSString *trafficId = [trafficData objectForKey:@"id"];
    NSString * closureTripUrl = @"http://travelmakerdata.co.nf/server/actions/tripClosureRequest.php";
    closureTripUrl = [NSString stringWithFormat:@"%@?trip_id_to_close=%@", closureTripUrl, trafficId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:closureTripUrl :^(NSData *data, NSError *connectionError) {
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
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        int success = [[jsonDict objectForKey:@"success"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success == 1)
            {
                [Common showAlert:@"הפעולה בוצעה בהצלחה" Message:@"בקשת הסגירה להסעה נשלחה בהצלחה לחברת ההסעות." ButtonName:@"אשר"];
            }
            else
            {
                [Common showAlert:@"תקלה" Message:@"בקשת הסגירה להסעה לא עברה בהצלחה. אנא צור קשר טלפוני עם חברת ההסעות." ButtonName:@"אשר"];
            }
        });

    }];

}


- (IBAction)clickWhatsapp:(id)sender
{
    [self handleWhatsapp];
}

- (IBAction)clickTelephone:(id)sender
{
    [self handleTelephone];
}

- (void)handleTapWhatsapp:(UITapGestureRecognizer *)recognizer
{
    [self handleWhatsapp];
}

- (void)handleTapTelephone:(UITapGestureRecognizer *)recognizer
{
    [self handleTelephone];
}


- (void)handleWhatsapp
{
    NSString *trafficId = [trafficData objectForKey:@"id"];
    NSString * phoneCounterUrl = @"http://travelmakerdata.co.nf/server/index.php?action=increaseCallCounter";
    phoneCounterUrl = [NSString stringWithFormat:@"%@&id=%@", phoneCounterUrl, trafficId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:phoneCounterUrl :^(NSData *data, NSError *connectionError) {
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
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSString * status = [jsonDict objectForKey:@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([status isEqualToString:@"done"] == YES)
            {
//                NSString *url = @"whatsapp://send";
//                url = [NSString stringWithFormat:@"%@?abid=%@", url, cellphone];
//                NSURL *whatsappURL = [NSURL URLWithString:url];
//                if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
//                {
//                    [[UIApplication sharedApplication] openURL: whatsappURL];
//                }
                NSURL *smsUrl = [NSURL URLWithString:@"sms:"];
                if ([[UIApplication sharedApplication] canOpenURL:smsUrl])
                    [[UIApplication sharedApplication] openURL:smsUrl];

            }
            else
            {
                [Common showAlert:@"תקלה" Message:@"הפעולה נכשלה" ButtonName:@"אשר"];
            }
        });

    }];

}

- (void)handleTelephone
{
    NSString *trafficId = [trafficData objectForKey:@"id"];
    NSString * phoneCounterUrl = @"http://travelmakerdata.co.nf/server/index.php?action=increaseCallCounter";
    phoneCounterUrl = [NSString stringWithFormat:@"%@&id=%@", phoneCounterUrl, trafficId];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:phoneCounterUrl :^(NSData *data, NSError *connectionError) {
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
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSString * status = [jsonDict objectForKey:@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([status isEqualToString:@"done"] == YES)
            {
                NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cellphone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
            else
            {
                [Common showAlert:@"תקלה" Message:@"הפעולה נכשלה" ButtonName:@"אשר"];
            }
        });
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerDetailCell"];
    
    if (cell == nil) {
        
        cell = [[DetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"offerDetailCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSString *date = nil;
    NSString *value = nil;
    switch (indexPath.row) {
        case 0:
            value = [trafficData objectForKey:@"num_passengers"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"סוג רכב"];
            }
            break;
        case 1:
            value = [trafficData objectForKey:@"time_start"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"שעת פינוי"];
            }
            break;
        case 2:
            value = [trafficData objectForKey:@"time_end"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"שעת סיום"];
            }
            break;
        case 3:
            value = [trafficData objectForKey:@"start_location"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"מוצא"];
            }
            break;
        case 4:
            value = [trafficData objectForKey:@"destination"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"יעד"];
            }
            break;
        case 5:
            date = [trafficData objectForKey:@"date_start"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString = [dateFormatter dateFromString:date];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            NSString *displayDate = [dateFormatter stringFromDate:dateFromString];
            
            [cell.lblValue setText:displayDate];
            [cell.lblKey setText:@"תאריך"];
            break;
    }
    
    return cell;
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
    controller.trafficDelegate = self.trafficDelegate;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)gotoNewRequestTrip
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    NewRequestController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newRequestVC"];
    controller.trafficDelegate = self.trafficDelegate;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)closePopup
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
