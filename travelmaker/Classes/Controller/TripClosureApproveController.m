//
//  TripClosureApproveController.m
//  Travel Maker
//
//  Created by developer on 1/4/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "TripClosureApproveController.h"

@implementation TripClosureApproveController

@synthesize lblMessage, lblTitle;
@synthesize strMessage, strTitle, strTripId;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [lblMessage setText:strMessage];
    [lblTitle setText:strTitle];
}

#pragma mark - IBAction
- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickCancel:(id)sender
{
    [self postResponseTripClosure:NO];
}

- (IBAction)clickApprove:(id)sender
{
    [self postResponseTripClosure:YES];
}

- (void)postResponseTripClosure:(BOOL)response
{
    NSString *responseUrl = @"http://travelmakerdata.co.nf/server/actions/responseToClosureRequest.php";
    responseUrl = [NSString stringWithFormat:@"%@?Response=%@", responseUrl, response?@"YES":@"NO"];
    responseUrl = [NSString stringWithFormat:@"%@&trip_id_to_close=%@", responseUrl, strTripId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:responseUrl :^(NSData *data, NSError *connectionError) {
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
            if(success == 0)
            {
                [Common showAlert:@"הפעולה בוצעה בהצלחה" Message:@"הודעתך לא עברה למשתמש, אנא צור איתו קשר טלפוני." ButtonName:@"אשר"];
            }
            else
            {
                [Common showAlert:@"תקלה" Message:@"הודעתך נשלחה בהצלחה." ButtonName:@"אשר"];
            }
        });
    }];

}

@end
