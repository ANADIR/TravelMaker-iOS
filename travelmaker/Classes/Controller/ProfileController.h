//
//  ProfileController.h
//  Travel Maker
//
//  Created by developer on 1/6/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "RightPaddingTextField.h"
#import <DYRateView.h>

@interface ProfileController : SuperViewController<UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    DYRateView *rateView;
}
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtFullname;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtPhone;
@property (nonatomic, weak) IBOutlet UIView *vwRateView;
@property (nonatomic, weak) IBOutlet UIButton *btnEdit;
@property (nonatomic, weak) IBOutlet UIImageView *imgEditName;
@property (nonatomic, weak) IBOutlet UIImageView *imgEditPhone;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickEdit:(id)sender;

@end
