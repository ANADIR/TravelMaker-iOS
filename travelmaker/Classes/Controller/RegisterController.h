//
//  RegisterController.h
//  Travel Maker
//
//  Created by developer on 12/7/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "PaddingTextField.h"

@interface RegisterController : SuperViewController

@property (weak, nonatomic) IBOutlet PaddingTextField *txtCellPhone;

- (IBAction)clickFacebook:(UIButton *)sender;
- (IBAction)clickEmail:(UIButton *)sender;
- (IBAction)clickGotoTraffic:(id)sender;

@end
