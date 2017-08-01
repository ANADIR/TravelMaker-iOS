//
//  RegisterController.m
//  Travel Maker
//
//  Created by developer on 12/7/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterEmailController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MFSideMenu.h"
#import "TrafficController.h"
#import "MenuController.h"
#import "AppDelegate.h"

@interface RegisterController ()

@end

@implementation RegisterController


#define PHONE_PADDING_WIDTH 20

@synthesize txtCellPhone;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [txtCellPhone setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickFacebook:(UIButton *)sender
{
    NSString *phone = [txtCellPhone text];
    
    if ([Common checkPhoneValidation:phone] == YES)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please wait...";

        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

            [hud hide:YES];
            if (error)
            {
                [Common showAlert:@"תקלה" Message:@"ניסיון הכניסה לפייסבוק נכשל" ButtonName:@"אשר"];
            }
            else
            {
                if(result.token)   // This means if There is current access token.
                {
                    // Token created successfully and you are ready to get profile info
                    [self getFacebookProfileInfos];
                }

            }
        }];
    }
    else
    {
        [Common showAlert:@"תקלה" Message:@"מספר הטלפון לא חוקי" ButtonName:@"אשר"];
    }
}

-(void)getFacebookProfileInfos {
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"name, picture, email"}];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"טוען נתונים של המשתמש...";

    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        [hud hide:YES];
        
        if(result)
        {
            NSLog(@"result: %@", result);
            
            NSString *email = [result objectForKey:@"email"];
            NSString *FBId = [result objectForKey:@"id"];
            NSString *name = [result objectForKey:@"name"];
            NSString *phone = [txtCellPhone text];
            NSString *password = @"";
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", FBId];

            
            
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSString *deviceId = delegate.deviceId;
            
            NSString * registerUrl = @"http://travelmakerdata.co.nf/server/index.php?action=register_user";
            registerUrl = [NSString stringWithFormat:@"%@&device_id=%@",registerUrl, deviceId];
            registerUrl = [NSString stringWithFormat:@"%@&FB_id=%@",    registerUrl, FBId];
            registerUrl = [NSString stringWithFormat:@"%@&fullname=%@", registerUrl, name];
            registerUrl = [NSString stringWithFormat:@"%@&cellphone=%@",registerUrl, phone];
            registerUrl = [NSString stringWithFormat:@"%@&image_url=%@",registerUrl, url];
            registerUrl = [NSString stringWithFormat:@"%@&email=%@",    registerUrl, email];
            registerUrl = [NSString stringWithFormat:@"%@&password=%@", registerUrl, password];
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"מבצע רישום";

            [DCDefines getHttpAsyncResponse:registerUrl :^(NSData *data, NSError *connectionError) {
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
                        [Common showAlert:@"תקלה" Message:@"רישום נכשל" ButtonName:@"אשר"];
                    }
                    else
                    {
                        NSString *user_id = [jsonDict objectForKey:@"user_id"];
                        NSString *FBId = [jsonDict objectForKey:@"FB_id"];
                        NSString *name = [jsonDict objectForKey:@"fullname"];
                        NSString *email = [jsonDict objectForKey:@"email"];
                        NSString *image_url = [jsonDict objectForKey:@"image_url"];
                        NSString *phone = [jsonDict objectForKey:@"cellphone"];
                        NSString *rank = [jsonDict objectForKey:@"rank"];
                        
                        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                        [preferences setObject:user_id forKey:@"user_id"];
                        [preferences setObject:name forKey:@"fullname"];
                        [preferences setObject:FBId forKey:@"fb_id"];
                        [preferences setObject:image_url forKey:@"image_url"];
                        [preferences setObject:phone forKey:@"cellphone"];
                        [preferences setObject:email forKey:@"email"];
                        [preferences setObject:rank forKey:@"rank"];
                        
                        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        
                        TrafficController *trafficController = [self.storyboard instantiateViewControllerWithIdentifier:@"trafficVC"];
                        MenuController *menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
                        
                        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                        containerWithCenterViewController:trafficController
                                                                        leftMenuViewController:menuController
                                                                        rightMenuViewController:nil];
                        
                        [trafficController setMenuController:container];
                        [menuController setMenuController:container];
                        
                        delegate.window.rootViewController = container;
                        [delegate.window makeKeyAndVisible];

                    }
                });
            }];

        }
        
    }];
    
    [connection start];
}

- (IBAction)clickEmail:(UIButton *)sender
{
    NSString *phone = [txtCellPhone text];
    if ([Common checkPhoneValidation:phone] == YES)
    {
        RegisterEmailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"registerEmailVC"];
        [controller setCellPhone:phone];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        [Common showAlert:@"תקלה" Message:@"מספר הטלפון לא חוקי" ButtonName:@"אשר"];
    }
}

- (IBAction)clickGotoTraffic:(id)sender
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    if (user_id == nil || [user_id isEqualToString:@""] == YES)
    {
        TrafficController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trafficVC"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        TrafficController *trafficController = [self.storyboard instantiateViewControllerWithIdentifier:@"trafficVC"];
        MenuController *menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:trafficController
                                                        leftMenuViewController:menuController
                                                        rightMenuViewController:nil];
        
        [trafficController setMenuController:container];
        [menuController setMenuController:container];
        
        delegate.window.rootViewController = container;
        [delegate.window makeKeyAndVisible];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= CELLPHONE_MAXLENGTH;
}

@end
