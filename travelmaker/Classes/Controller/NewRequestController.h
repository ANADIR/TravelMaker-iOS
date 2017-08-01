//
//  NewRequestController.h
//  Travel Maker
//
//  Created by developer on 12/14/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import "RightPaddingTextField.h"
#import "UIPlaceHolderTextView.h"
#import "ZSYPopoverListView.h"
#import "TrafficController.h"

@interface NewRequestController : SuperViewController <ZSYPopoverListDatasource, ZSYPopoverListDelegate>
{
    UIDatePicker *timePicker;
    UIDatePicker *datePicker;
}

@property (nonatomic, assign) id<TrafficDelegate> trafficDelegate;

@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtTypeVehicle;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtEvacuationTime;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtStartArea;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtEndArea;
@property (nonatomic, weak) IBOutlet RightPaddingTextField *txtDate;
@property (nonatomic, weak) IBOutlet UIPlaceHolderTextView *txtMoreInfo;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickSend:(id)sender;
- (IBAction)clickTypeVehicle:(id)sender;

@end
