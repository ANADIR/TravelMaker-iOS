//
//  MyMessageController.m
//  Travel Maker
//
//  Created by developer on 12/29/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "MyMessageController.h"
#import "MyMessageCell.h"
#import "MessageDetailController.h"
#import "UIViewController+MJPopupViewController.h"
#import "MyMessageDetailController.h"


@implementation MyMessageController

@synthesize tblMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayMessageData = [[NSMutableArray alloc] init];

    [self loadTrafficData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadTrafficData
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    if (user_id == nil || [user_id isEqualToString:@""] == YES)
    {
        [Common showAlert:@"תקלה" Message:@"אנא בצע רישום על מנת להמשיך" ButtonName:@"אשר"];
        return;
    }

    NSString * getMessageUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getTrafficDataByUser";
    getMessageUrl = [NSString stringWithFormat:@"%@&user_id=%@", getMessageUrl, user_id];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:getMessageUrl :^(NSData *data, NSError *connectionError) {
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
        self.arrayMessageData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.arrayMessageData != nil)
            {
                [tblMessage reloadData];
            }
        });
    }];
    
}

#pragma mark - IBAction
- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayMessageData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mymessageCell"];
    
    if (cell == nil) {
        
        cell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mymessageCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *messageData = [self.arrayMessageData objectAtIndex:indexPath.row];

    NSString *strStart = [messageData objectForKey:@"start_location"];
    NSString *strType = [messageData objectForKey:@"traffic_type"];
    NSString *strEnd = @"";
    if ([strType isEqualToString:@"requested"] == YES)
        strEnd = [messageData objectForKey:@"area"];
    else
        strEnd = [messageData objectForKey:@"destination"];
    
    NSString *strLocation = [NSString stringWithFormat:@"%@ - %@", strStart, strEnd];
    NSString *strDateStart = [messageData objectForKey:@"date_start"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:strDateStart];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *displayDate = [dateFormatter stringFromDate:dateFromString];
    
    [cell.lblLocation setText:strLocation];
    [cell.lblDateStart setText:displayDate];
    
    if (indexPath.row % 2 == 0)
    {
        [cell.layer setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor];
    }
    else
    {
        [cell.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    }
    
    cell.leftUtilityButtons = [self leftButtons];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *messageData = [self.arrayMessageData objectAtIndex:indexPath.row];

    MyMessageDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myMessageDetailVC"];
    [controller setTrafficData:messageData];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)cellDeleted:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblMessage];
    NSIndexPath *indexPath = [tblMessage indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *messageData = [self.arrayMessageData objectAtIndex:indexPath.row];
    NSString *messageId = [messageData objectForKey:@"id"];

    NSString * deleteMessageUrl = @"http://travelmakerdata.co.nf/server/index.php?action=removeTripAd";
    deleteMessageUrl = [NSString stringWithFormat:@"%@&id=%@", deleteMessageUrl, messageId];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:deleteMessageUrl :^(NSData *data, NSError *connectionError) {
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
                [Common showAlert:@"תקלה" Message:@"מחיקת הודעה נכשלה" ButtonName:@"אשר"];
            }
            else
            {
                [Common showAlert:@"הפעולה בוצעה בהצלחה" Message:@"נמחק בהצלחה" ButtonName:@"אשר"];
                
                [self loadTrafficData];
            }
        });

    }];
    
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor lightGrayColor]
                                                icon:[UIImage imageNamed:@"Delete"]];
    
    return leftUtilityButtons;
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self cellDeleted:cell];
            
            break;
            
        default:
            break;
    }
}

@end
