//
//  MessageController.m
//  Travel Maker
//
//  Created by developer on 1/4/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "MessageDetailController.h"
#import "UIViewController+MJPopupViewController.h"
#import "TripClosureApproveController.h"
#import "RankController.h"

@implementation MessageController
@synthesize tblMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayMessageData = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        [Common showAlert:@"תקלה" Message:@"Please login first" ButtonName:@"אשר"];
        return;
    }
    
    NSString *getMessageUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getAllMsgByUser";
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
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (cell == nil) {
        
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *messageData = [self.arrayMessageData objectAtIndex:indexPath.row];
    
    [cell.lblMessage setText:[messageData objectForKey:@"text"]];
    [cell.lblTitle setText:[messageData objectForKey:@"title"]];
    
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
    NSString *messageType = [messageData objectForKey:@"msg_type"];
    
    if ([messageType isEqualToString:@"closure_request_msg"] == YES)
    {
        TripClosureApproveController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tripClosureVC"];
        controller.strTitle = [messageData objectForKey:@"title"];
        controller.strMessage = [messageData objectForKey:@"text"];
        controller.strTripId = [messageData objectForKey:@"trip_id_to_close"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if ([messageType isEqualToString:@"rank_msg"] == YES)
    {
        RankController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"rankVC"];
        controller.rankedUserID = [messageData objectForKey:@"user_id_to_rank"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        MessageDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"messageDetailVC"];
        [controller.view setFrame:CGRectMake(0, 100, 300, 200)];
        controller.strTitle = [messageData objectForKey:@"title"];
        controller.strMessage = [messageData objectForKey:@"text"];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }
}

- (void)cellDeleted:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblMessage];
    NSIndexPath *indexPath = [tblMessage indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *messageData = [self.arrayMessageData objectAtIndex:indexPath.row];
    NSString *messageId = [messageData objectForKey:@"id"];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    
    NSString *deleteMessageUrl = @"http://travelmakerdata.co.nf/server/index.php?action=deleteMsgByUser";
    deleteMessageUrl = [NSString stringWithFormat:@"%@&id=%@", deleteMessageUrl, messageId];
    deleteMessageUrl = [NSString stringWithFormat:@"%@&user_id=%@", deleteMessageUrl, user_id];
    
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
