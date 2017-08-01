//
//  LoginController.h
//  Travel Maker
//
//  Created by developer on 12/4/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "PaddingTextField.h"

@interface LoginController : SuperViewController

@property (nonatomic, weak) IBOutlet UIView *vwEmail;
@property (nonatomic, weak) IBOutlet UIView *vwPasswd;
@property (nonatomic, weak) IBOutlet PaddingTextField *txtEmail;
@property (nonatomic, weak) IBOutlet PaddingTextField *txtPasswd;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickFacebook:(id)sender;
- (IBAction)clickEnter:(id)sender;
- (IBAction)clickReminder:(id)sender;

@end
