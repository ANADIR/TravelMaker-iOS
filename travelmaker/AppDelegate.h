//
//  AppDelegate.h
//  Travel Maker
//
//  Created by developer on 12/4/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *pushGotKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, strong) NSString* deviceId;

@end

