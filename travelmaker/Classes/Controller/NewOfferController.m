//
//  NewOfferController.m
//  Travel Maker
//
//  Created by developer on 12/14/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "NewOfferController.h"

@implementation NewOfferController

@synthesize txtDate, txtEndArea, txtEndTime, txtMoreInfo, txtPrice, txtStartArea, txtStartTime, txtTypeVehicle;
@synthesize trafficDelegate;

NSMutableArray *arrayOfferCarType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtMoreInfo setPlaceholder:@"פרטים נוספים"];
    [txtMoreInfo setPlaceholderColor:[UIColor colorWithRed:50.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f]];
    [txtMoreInfo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NewFieldFreetext"]]];
    
    arrayOfferCarType = [[NSMutableArray alloc] initWithObjects:@"4",@"10",@"14",@"16", @"20", @"35", @"52", @"60", nil];
    
    // Time Picker for StartTime
    startTimePicker = [[UIDatePicker alloc] init];
    startTimePicker.datePickerMode = UIDatePickerModeTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [startTimePicker setLocale:locale];
    [startTimePicker addTarget:self action:@selector(startTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [txtStartTime setInputView:startTimePicker];
    
    // Time Picker for EndTime
    endTimePicker = [[UIDatePicker alloc] init];
    endTimePicker.datePickerMode = UIDatePickerModeTime;
    [endTimePicker setLocale:locale];
    [endTimePicker addTarget:self action:@selector(endTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [txtEndTime setInputView:endTimePicker];

    
    // Date Picker for Date
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [txtDate setInputView:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction
- (IBAction)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSend:(id)sender
{
    // check value's validation
    NSString *textVehicle = [txtTypeVehicle text];
    if (textVehicle == nil || [textVehicle isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס את סוג הרכב" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textStartTime = [txtStartTime text];
    if (textStartTime == nil || [textStartTime isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס זמן התחלה" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textEndTime = [txtEndTime text];
    if (textEndTime == nil || [textEndTime isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס זמן סיום" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textStartArea = [txtStartArea text];
    if (textStartArea == nil || [textStartArea isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס מוצא" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textEndArea = [txtEndArea text];
    if (textEndArea == nil || [textEndArea isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס יעד" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textDate = [txtDate text];
    if (textDate == nil || [textDate isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס תאריך" ButtonName:@"אשר"];
        return;
    }
    
    NSString *textMore = [txtMoreInfo text];
    if (textMore == nil || [textMore isEqualToString:@""])
    {
        textMore = @"";
    }
    
    NSString *textPrice = [txtPrice text];
    if (textPrice == nil || [textPrice isEqualToString:@""])
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס מחיר" ButtonName:@"אשר"];
        return;
    }

    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    
    // convert date to DDMMYYYY
    NSString *startDate = [NSString stringWithFormat:@"%@ %@", textDate, textStartTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate *date = [dateFormatter dateFromString:startDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *convertDate = [dateFormatter stringFromDate:date];
    
    // get current date
    NSDate *currentDate = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *createDate = [dateFormatter stringFromDate:currentDate];
    
    
    // Post a trip
    NSString * postTripUrl = @"http://travelmakerdata.co.nf/server/index.php?action=add_trip";
    postTripUrl = [NSString stringWithFormat:@"%@&id=%@", postTripUrl, @"1"];
    postTripUrl = [NSString stringWithFormat:@"%@&author_id=%@", postTripUrl, user_id];
    postTripUrl = [NSString stringWithFormat:@"%@&traffic_type=%@", postTripUrl, @"offered"];
    postTripUrl = [NSString stringWithFormat:@"%@&start_location=%@", postTripUrl, textStartArea];
    postTripUrl = [NSString stringWithFormat:@"%@&destination=%@", postTripUrl, textEndArea];
    postTripUrl = [NSString stringWithFormat:@"%@&area=%@", postTripUrl, @""];
    postTripUrl = [NSString stringWithFormat:@"%@&date_start=%@", postTripUrl, convertDate];
    postTripUrl = [NSString stringWithFormat:@"%@&time_start=%@", postTripUrl, textStartTime];
    postTripUrl = [NSString stringWithFormat:@"%@&time_end=%@", postTripUrl, textEndTime];
    postTripUrl = [NSString stringWithFormat:@"%@&num_passengers=%@", postTripUrl, textVehicle];
    postTripUrl = [NSString stringWithFormat:@"%@&free_text=%@", postTripUrl, textMore];
    postTripUrl = [NSString stringWithFormat:@"%@&price=%@", postTripUrl, textPrice];
    postTripUrl = [NSString stringWithFormat:@"%@&status=%@", postTripUrl, @"open"];
    postTripUrl = [NSString stringWithFormat:@"%@&createDate=%@", postTripUrl, createDate];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:postTripUrl :^(NSData *data, NSError *connectionError) {
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
            if([status isEqualToString:@"done"] == NO) {
                [Common showAlert:@"תקלה" Message:@"יצירת נסיעה חדשה נכשלה" ButtonName:@"אשר"];
            }
            else
            {
                if ([self.trafficDelegate respondsToSelector:@selector(trafficDetailControllerDismissed:)])
                {
                    [self.trafficDelegate trafficDetailControllerDismissed:NO];
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
        
    }];
    
}

- (IBAction)clickTypeVehicle:(id)sender
{
    int height = [arrayOfferCarType count] * 45 + 30;
    
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 250, height)];
    listView.titleName.text = @"סוג רכב";
    listView.datasource = self;
    listView.delegate = self;
    
    [listView show];
}

- (void)startTimeChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:startTimePicker.date];
    
    txtStartTime.text = currentTime;
}

- (void)endTimeChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:endTimePicker.date];
    
    txtEndTime.text = currentTime;
}


- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *currentTime = [dateFormatter stringFromDate:datePicker.date];
    
    txtDate.text = currentTime;
}

#pragma mark - ZSYPopoverListView
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfferCarType.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = arrayOfferCarType[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
    cell.textLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtTypeVehicle.text = arrayOfferCarType[indexPath.row];
    
    [tableView dismiss];
}

@end
