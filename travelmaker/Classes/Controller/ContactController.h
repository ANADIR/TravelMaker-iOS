//
//  ContactController.h
//  Travel Maker
//
//  Created by developer on 1/5/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "RightPaddingTextField.h"
#import "UIPlaceHolderTextView.h"

@interface ContactController : SuperViewController

@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtFullName;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtEmail;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtPhone;
@property (nonatomic, weak) IBOutlet UIPlaceHolderTextView *txtDescription;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickSubmit:(id)sender;

@end
