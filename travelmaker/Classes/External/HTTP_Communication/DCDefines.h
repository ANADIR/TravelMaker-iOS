//
//  DCDefines.h
//

#ifndef DrakeCircus_DCDefines_h
#define DrakeCircus_DCDefines_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DCDefines : NSObject
+ (void) getHttpAsyncResponse:(NSString*) request_url :(void(^)(NSData *data, NSError *connectionError))handler;
+ (void) downloadImageFromServer:(NSString*) request_url :(void(^)(NSData *data, NSError *connectionError))handler;
+ (NSData *)removeUnescapedCharacter:(NSData *)inputData;
+ (BOOL) validateEmail: (NSString *) candidate;
+ (BOOL) validateNumeric: (NSString *) candidate;
+ (void) pushNotification:(NSString *)msg SectionType:(NSInteger)sectionType Major:(NSInteger)major Minor:(NSInteger)minor;
+ (BOOL) isNotifiyEnableBluetooth;
+ (BOOL) isNotifyEnableLocation;
+ (BOOL) isNotifyEnableNotification;
+ (void) makePhoneCall:(NSString *) phonenumber;
+ (void) openUrlWithSafari:(NSString *) url;

@end

#endif
