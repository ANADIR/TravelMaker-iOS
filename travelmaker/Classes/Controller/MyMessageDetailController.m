//
//  MyMessageDetailController.m
//  Travel Maker
//
//  Created by developer on 1/10/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "MyMessageDetailController.h"
#import <DYRateView.h>
#import "DetailViewCell.h"

@implementation MyMessageDetailController
@synthesize trafficData;
@synthesize lblDescription, lblTrip, lblCompany;
@synthesize tblTraffic;
@synthesize vwCompany;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *start_location = [trafficData objectForKey:@"start_location"];
    NSString *strType = [trafficData objectForKey:@"traffic_type"];
    NSString *strEnd = @"";
    if ([strType isEqualToString:@"requested"] == YES)
        strEnd = [trafficData objectForKey:@"area"];
    else
        strEnd = [trafficData objectForKey:@"destination"];
    NSString *txtTrip = [NSString stringWithFormat:@"%@ - %@", strEnd, start_location];
    [lblTrip setText:txtTrip];
    
    id freeText = [trafficData objectForKey:@"free_text"];
    NSString *txtFreeText = @"";
    if (freeText != [NSNull null])
        txtFreeText = (NSString *)freeText;
    
    [lblDescription setText:txtFreeText];
    
    NSString *txtCompany = [trafficData objectForKey:@"fullname"];
    if (txtCompany == (id)[NSNull null])
        [lblCompany setText:@""];
    else
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestDetailCell"];
    
    if (cell == nil) {
        
        cell = [[DetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"requestDetailCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSString *date = nil;
    NSString *value = nil;
    NSString *strType = [trafficData objectForKey:@"traffic_type"];

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
            value = [trafficData objectForKey:@"start_location"];
            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"מוצא"];
            }
            break;
        case 3:
            if ([strType isEqualToString:@"requested"] == YES)
                value = [trafficData objectForKey:@"area"];
            else
                value = [trafficData objectForKey:@"destination"];

            if (value != nil && value != (id)[NSNull null])
            {
                [cell.lblValue setText:value];
                [cell.lblKey setText:@"לאזור"];
            }
            break;
        case 4:
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

@end
