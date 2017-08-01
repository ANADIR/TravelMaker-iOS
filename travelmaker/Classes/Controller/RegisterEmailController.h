//
//  RegisterEmailController.h
//  Travel Maker
//
//  Created by developer on 12/7/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "PaddingTextField.h"

@interface RegisterEmailController : SuperViewController

@property (copy, nonatomic) NSString * cellPhone;

@property (nonatomic, weak) IBOutlet UIView *vwEmail;
@property (nonatomic, weak) IBOutlet UIView *vwPasswd;
@property (nonatomic, weak) IBOutlet PaddingTextField *txtEmail;
@property (nonatomic, weak) IBOutlet PaddingTextField *txtPasswd;

- (IBAction)clickBack:(UIButton *)sender;
- (IBAction)clickContinue:(UIButton *)sender;

@end
