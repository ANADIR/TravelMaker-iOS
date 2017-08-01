//
//  AppDelegate.m
//  Travel Maker
//
//  Created by developer on 12/4/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "AppDelegate.h"
#import "DCDefines.h"
#import "UIDevice+IdentifierAddition.h"
#import <AdSupport/AdSupport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Firebase.h"

@interface AppDelegate ()
@property(nonatomic, strong) void (^registrationHandler)(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, assign) BOOL subscribedToTopic;

@end

NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

bool isNeedGoUpdate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    _pushGotKey = @"onPushReceived";
    
    isNeedGoUpdate = NO;
    
    
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
    } else {
        // iOS 8 or later
        // [END_EXCLUDE]
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    // [END register_for_remote_notifications]
    
    [FIRApp configure];
    
    // Add observer to listen for the token refresh notification.
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onTokenRefresh)
     name:kFIRInstanceIDTokenRefreshNotification object:nil];

    
    return YES;
}


- (void) registerDeviceWithType {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationToken = @"registrationToken";
    [preferences setObject:self.registrationToken forKey:registrationToken];
    
    self.deviceId = [self UniqueAppId];
    NSString *deviceIdStored = @"deviceIdStored";
    [preferences setObject:self.deviceId forKey:deviceIdStored];
    NSLog(@"deviceID: %@", self.deviceId);
    
    NSString * registerDeviceUrl = @"http://travelmakerdata.co.nf/server/index.php?action=register_device_push&regid=";
    NSString * url = [NSString stringWithFormat:@"%@%@&device_id=%@&device_type=iOS",registerDeviceUrl,self.registrationToken, self.deviceId];
    
    [DCDefines getHttpAsyncResponse:url :^(NSData *data, NSError *connectionError) {
        NSData *responseData = data;
        if (responseData == nil) {
            return;
        }
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"===============%@",string);
    }];
}

-(NSString*)UniqueAppId
{
    NSString *strApplicationUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    return strApplicationUUID;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    
    NSString *token = [[FIRInstanceID instanceID] token];
    self.registrationToken = token;
    
    [self registerDeviceWithType];
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    
    // [END receive_apns_token_error]
    
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    
    if (userInfo != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                            object:nil
                                                          userInfo:userInfo];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // This works only if the app started the GCM service
    /*
     [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
     //
     NSString * title = [userInfo valueForKey:@"title"];
     NSString * message = [userInfo valueForKey:@"message"];
     
     [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"AppIcon"] title:title message:message isAutoHide:NO onTouch:^{
     [HDNotificationView hideNotificationViewOnComplete:nil];
     // UIViewController *vc = self.window.rootViewController;
     // ContactController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"contactViewController"];
     // [vc presentViewController:pvc animated:YES completion:nil];
     }];
     */
    //application.applicationIconBadgeNumber = 0;
    
    /*
    
    NSLog(@"Notification received: %@", userInfo);
    if (self.registrationToken != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:_pushGotKey
                                                            object:nil
                                                          userInfo:userInfo];
        NSString * title = [userInfo valueForKey:@"title"];
        NSString * message = [userInfo valueForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"אישור"
                                              otherButtonTitles:nil];
        [alert show];
        /*
         UIViewController *vc = self.window.rootViewController;
         ContactController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"contactViewController"];
         [vc presentViewController:pvc animated:YES completion:nil];
         */
        
        
    //} else {
        isNeedGoUpdate = YES;
    //}
    
    //if (application.applicationState == UIApplicationStateActive)
    //{
        
    
//        NSString * title = [userInfo valueForKey:@"title"];
//        NSString * message = [userInfo valueForKey:@"message"];
//        [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"AppIcon"] title:title message:message isAutoHide:NO onTouch:^{
//            [HDNotificationView hideNotificationViewOnComplete:nil];
//            UIViewController *vc = self.window.rootViewController;
//            ContactController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"contactViewController"];
//            [vc presentViewController:pvc animated:YES completion:nil];
//        }];
        
   // }

    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    
    NSLog(@"Notification received: %@", userInfo);
    
     [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    
    handler(UIBackgroundFetchResultNoData);
    
    //When app is already open
    
    if (self.registrationToken != nil)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_pushGotKey object:nil userInfo:userInfo];
        
    } else {
        isNeedGoUpdate = YES;
    }
    
}


- (void)onTokenRefresh {
    
    NSString *token = [[FIRInstanceID instanceID] token];
    self.registrationToken = token;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //    [[GCMService sharedInstance] disconnect];
    //
    //  // [START_EXCLUDE]
    //
    //  _connectedToGCM = NO;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
    } else {
        // Will send message, you can save the messageID to track the message
    }
}

- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
}

- (void)didDeleteMessagesOnServer {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
@end
