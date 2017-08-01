//
//  RegisterEmailController.m
//  Travel Maker
//
//  Created by developer on 12/7/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "RegisterEmailController.h"
#import "MFSideMenu.h"
#import "TrafficController.h"
#import "MenuController.h"
#import "AppDelegate.h"

@interface RegisterEmailController ()

@end

@implementation RegisterEmailController

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


- (IBAction)clickBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickContinue:(UIButton *)sender
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
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *deviceId = delegate.deviceId;
    
    NSString * registerUrl = @"http://travelmakerdata.co.nf/server/index.php?action=register_user";
    registerUrl = [NSString stringWithFormat:@"%@&device_id=%@",registerUrl, deviceId];
    registerUrl = [NSString stringWithFormat:@"%@&FB_id=%@",    registerUrl, @""];
    registerUrl = [NSString stringWithFormat:@"%@&fullname=%@", registerUrl, @""];
    registerUrl = [NSString stringWithFormat:@"%@&cellphone=%@",registerUrl, self.cellPhone];
    registerUrl = [NSString stringWithFormat:@"%@&image_url=%@",registerUrl, @"none"];
    registerUrl = [NSString stringWithFormat:@"%@&email=%@",    registerUrl, email];
    registerUrl = [NSString stringWithFormat:@"%@&password=%@", registerUrl, passwd];


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
@end
