//
//  LoginController.m
//  Travel Maker
//
//  Created by developer on 12/4/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "LoginController.h"
#import "MFSideMenu.h"
#import "TrafficController.h"
#import "MenuController.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginController ()

@end

@implementation LoginController

@synthesize vwEmail, vwPasswd;
@synthesize txtEmail, txtPasswd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIGraphicsBeginImageContext(vwEmail.frame.size);
    [[UIImage imageNamed:@"FieldEmail"] drawInRect:vwEmail.bounds];
    UIImage *imgEmail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [vwEmail setBackgroundColor:[UIColor colorWithPatternImage:imgEmail]];
    
    UIGraphicsBeginImageContext(vwPasswd.frame.size);
    [[UIImage imageNamed:@"FieldPassword"] drawInRect:vwPasswd.bounds];
    UIImage *imgPasswd = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [vwPasswd setBackgroundColor:[UIColor colorWithPatternImage:imgPasswd]];
    
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

- (IBAction)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickFacebook:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"אנא המתן...";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        [hud hide:YES];
        if (error)
        {
            [Common showAlert:@"תקלה" Message:@"ניסיון הכניסה לפייסבוק נכשל" ButtonName:@"אשר"];
        }
        else
        {
            NSLog(@"result: %@", result);
            if(result.token)   // This means if There is current access token.
            {
                // Token created successfully and you are ready to get profile info
                [self getFacebookProfileInfos];
            }
            
        }
    }];
}

-(void)getFacebookProfileInfos {
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"name, picture, email"}];

    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        [hud hide:YES];
        
        if(result)
        {
            NSLog(@"result: %@", result);
            
            NSString *FBId = [result objectForKey:@"id"];
            
            NSString * registerUrl = @"http://travelmakerdata.co.nf/server/index.php?action=facebook_login";
            registerUrl = [NSString stringWithFormat:@"%@&FB_id=%@",registerUrl, FBId];
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"מבצע התחברות...";
            
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
                    if([status isEqualToString:@"logged OK"] == NO) {
                        
//                      [Common showAlert:@"Error" Message:@"Failed on logging in." ButtonName:@"Ok"];

                        [self registerUserByFacebook:result];
                    }
                    else
                    {
                        [self loginWithUserInformation:jsonDict];
                    }
                });
            }];
            
        }
        
    }];
    
    [connection start];
}

- (IBAction)clickEnter:(id)sender
{
    NSString *email = [txtEmail text];
    if ([Common checkEmailValidation:email] == NO)
    {
        [Common showAlert:@"תקלה" Message:@"אנא הכנס כתובת אימייל תקינה" ButtonName:@"אשר"];
        return;
    }
    
    NSString *passwd = [txtPasswd text];
    if ([Common checkPasswordValidation:passwd] == NO)
    {
        [Common showAlert:@"תקלה" Message:@"אנא הזן סיסמה באורך 6 תווים לפחות" ButtonName:@"אשר"];
        return;
    }

    NSString * loginUrl = @"http://travelmakerdata.co.nf/server/index.php?action=login_user";
    loginUrl = [NSString stringWithFormat:@"%@&email=%@",loginUrl, email];
    loginUrl = [NSString stringWithFormat:@"%@&password=%@",loginUrl, passwd];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:loginUrl :^(NSData *data, NSError *connectionError) {
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
            if([status isEqualToString:@"logged OK"] == NO) {
                [Common showAlert:@"תקלה" Message:@"הכניסה נכשלה" ButtonName:@"אשר"];
            }
            else
            {
                [self loginWithUserInformation:jsonDict];
            }
        });
    }];
    
}

- (IBAction)clickReminder:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"שכחתי סיסמה"
                                                     message:@"אנא הכנס את כתובת האימייל שאיתו בצעת הרשמה"
                                                    delegate:self
                                           cancelButtonTitle:@"בטל"
                                           otherButtonTitles:@"אשר", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // cancel
    }
    else
    {
        // Ok
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSString *email = [alertTextField text];
        if ([Common checkEmailValidation:email] == NO)
        {
            [Common showAlert:@"תקלה" Message:@"אנא הכנס כתובת אימייל תקינה" ButtonName:@"אשר"];
            return;
        }
        
        NSString * reminderUrl = @"http://travelmakerdata.co.nf/server/index.php?action=email_password";
        reminderUrl = [NSString stringWithFormat:@"%@&email=%@",reminderUrl, email];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DCDefines getHttpAsyncResponse:reminderUrl :^(NSData *data, NSError *connectionError) {
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
                if([status isEqualToString:@"email sent"] == NO) {
                    [Common showAlert:@"תקלה" Message:@"כתובת האימייל לא קיימת במאגר שלנו" ButtonName:@"אשר"];
                }
                else
                    [Common showAlert:@"הפעולה בוצעה בהצלחה" Message:@"אימייל נשלח" ButtonName:@"אשר"];
            });
        }];

        
    }
}


- (void)registerUserByFacebook:(id) result
{
    NSString *email = [result objectForKey:@"email"];
    NSString *FBId = [result objectForKey:@"id"];
    NSString *name = [result objectForKey:@"name"];
//  NSString *phone = [txtCellPhone text];
    NSString *password = @"";
//  NSString *url = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", FBId];
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *deviceId = delegate.deviceId;
    
    NSString * registerUrl = @"http://travelmakerdata.co.nf/server/index.php?action=register_user";
    registerUrl = [NSString stringWithFormat:@"%@&device_id=%@",registerUrl, deviceId];
    registerUrl = [NSString stringWithFormat:@"%@&FB_id=%@",    registerUrl, FBId];
    registerUrl = [NSString stringWithFormat:@"%@&fullname=%@", registerUrl, name];
    registerUrl = [NSString stringWithFormat:@"%@&cellphone=%@",registerUrl, @""];
    registerUrl = [NSString stringWithFormat:@"%@&image_url=%@",registerUrl, url];
    registerUrl = [NSString stringWithFormat:@"%@&email=%@",    registerUrl, email];
    registerUrl = [NSString stringWithFormat:@"%@&password=%@", registerUrl, password];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
                [self loginWithUserInformation:jsonDict];
            }
        });
    }];
}

- (void)loginWithUserInformation:(NSDictionary*)jsonDict
{
    NSString *user_id = [jsonDict objectForKey:@"user_id"];
    NSString *FBId = [jsonDict objectForKey:@"FB_id"];
    NSString *name = [jsonDict objectForKey:@"fullname"];
    NSString *email = [jsonDict objectForKey:@"email"];
  NSString *image_url = [jsonDict objectForKey:@"image_url"];
//    NSString *image_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", FBId];
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
    [preferences synchronize];
    
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
@end
