//
//  RankController.h
//  Travel Maker
//
//  Created by developer on 1/7/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"
#import <DYRateView.h>

@interface RankController : SuperViewController
{
    DYRateView *rateView;
}
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel *lblFullname;
@property (nonatomic, weak) IBOutlet UIView *vwRateView;
@property (nonatomic, weak) NSString *rankedUserID;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickSend:(id)sender;
- (void)loadProfileInformation:(NSString*)userID;


@end
