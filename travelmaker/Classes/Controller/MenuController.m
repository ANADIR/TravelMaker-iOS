//
//  MenuController.m
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "MenuController.h"
#import "MyMessageController.h"
#import "MessageController.h"
#import "AboutServiceController.h"
#import "ContactController.h"
#import "ProfileController.h"
#import "TutorialController.h"
#import "TermsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MenuController

@synthesize vwAbout, vwContact, vwMessage, vwMyMessage, vwTerms, vwProfile, vwPush, vwShare;
@synthesize btnPush, btnLogout;
@synthesize imgAvatar;
@synthesize lblName;

BOOL bPushEnabled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bPushEnabled = YES;
    [btnPush setSelected:bPushEnabled];
    
    // Add tapGesture
    UITapGestureRecognizer *tapAbout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAbout)];
    tapAbout.delegate = self;
    [vwAbout addGestureRecognizer:tapAbout];
    
    UITapGestureRecognizer *tapContact = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContact)];
    tapContact.delegate = self;
    [vwContact addGestureRecognizer:tapContact];
    
    UITapGestureRecognizer *tapMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMessage)];
    tapMessage.delegate = self;
    [vwMessage addGestureRecognizer:tapMessage];
    
    UITapGestureRecognizer *tapMyMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMyMessage)];
    tapMyMessage.delegate = self;
    [vwMyMessage addGestureRecognizer:tapMyMessage];

    UITapGestureRecognizer *tapPrivacy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTerms)];
    tapPrivacy.delegate = self;
    [vwTerms addGestureRecognizer:tapPrivacy];

    UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapProfile)];
    tapProfile.delegate = self;
    [vwProfile addGestureRecognizer:tapProfile];

    UITapGestureRecognizer *tapPush = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPush)];
    tapPush.delegate = self;
    [vwPush addGestureRecognizer:tapPush];
    
    UITapGestureRecognizer *tapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapShare)];
    tapShare.delegate = self;
    [vwShare addGestureRecognizer:tapShare];


    // make underline text
    NSArray * objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    NSArray * keys = [[NSArray alloc] initWithObjects:NSUnderlineStyleAttributeName, nil];
    NSDictionary * linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:btnLogout.titleLabel.text attributes:linkAttributes];
    [btnLogout.titleLabel setAttributedText:attributedString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // full name
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *fullname = [preferences objectForKey:@"fullname"];
    [lblName setText:fullname];
    
    // profile picture
    NSString *imgUrl = [preferences objectForKey:@"image_url"];
    if (imgUrl != nil && [imgUrl isEqualToString:@""] == NO)
    {
        [imgAvatar sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2.0f;
        imgAvatar.clipsToBounds = YES;
    }
}
#pragma mark - UITapGestureRecognizer handler
- (void)handleTapAbout
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    AboutServiceController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutServiceVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)handleTapMessage
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    MessageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"messageVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];

}

- (void)handleTapMyMessage
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    MyMessageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myMessageVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)handleTapContact
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    ContactController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"contactVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];

}

- (void)handleTapTerms
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    TermsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"termsServiceVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)handleTapProfile
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];
    
    ProfileController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)handleTapPush
{
    bPushEnabled = !bPushEnabled;
    [btnPush setSelected:bPushEnabled];
    
    // enable / disable push notification
    if (bPushEnabled)
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)handleTapShare
{
    [self.menuController setMenuState:MFSideMenuStateClosed completion:^{ }];

    NSString *texttoshare = @"כנס עכשיו לחנות אפסטור ותוריד את אפליקצית Travel Maker לחברות הסעות. מומלץ!";
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}


#pragma mark - IBAction
- (void)clickLogout:(id)sender
{
    // clear all stored values
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    TutorialController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)clickPush:(id)sender
{
    bPushEnabled = !bPushEnabled;
    [btnPush setSelected:bPushEnabled];
    
    // enable / disable push notification
    if (bPushEnabled)
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

@end
