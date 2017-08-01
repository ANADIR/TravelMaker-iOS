//
//  Common.m
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (BOOL)checkEmailValidation:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)checkPasswordValidation:(NSString *)password
{
    NSInteger length = [password length];
    return length >= PASSWORD_MINENGTH? YES: NO;
}

+ (BOOL)checkPhoneValidation:(NSString *)phone
{
    NSInteger length = [phone length];
    
    if (length < CELLPHONE_MAXLENGTH)
        return NO;
    
    return YES;
}

+(void)showAlert:(NSString *)title Message:(NSString *)message ButtonName:(NSString *)buttonname
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonname
                                          otherButtonTitles:nil];
    [alert show];
}

@end

