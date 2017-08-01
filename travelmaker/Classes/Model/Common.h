//
//  Common.h
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <UIKit/UIKit.h>

@interface Common : NSObject

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define CELLPHONE_MAXLENGTH 10
#define PASSWORD_MINENGTH   6


+ (BOOL)checkEmailValidation:(NSString *)email;
+ (BOOL)checkPasswordValidation:(NSString *)password;
+ (BOOL)checkPhoneValidation:(NSString *)phone;
+ (void)showAlert:(NSString *)title Message:(NSString *)message ButtonName:(NSString *)buttonname;


@end

#endif /* Common_h */
