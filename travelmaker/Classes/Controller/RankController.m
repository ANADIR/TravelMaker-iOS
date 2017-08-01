//
//  RankController.m
//  Travel Maker
//
//  Created by developer on 1/7/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "RankController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RankController

@synthesize imgAvatar;
@synthesize lblFullname;
@synthesize vwRateView;
@synthesize rankedUserID;


#define RATEVIEW_WIDTH  90
#define RATEVIEW_HEIGHT 20

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    //NSString *fullname = [preferences objectForKey:@"fullname"];
    //[lblFullname setText:fullname];
    
    // ratebar
    CGRect frame = vwRateView.frame;
    CGRect rateFrame = CGRectMake((frame.size.width - RATEVIEW_WIDTH) / 2.0,
                                  (frame.size.height - RATEVIEW_HEIGHT) / 2.0,
                                  RATEVIEW_WIDTH,
                                  RATEVIEW_HEIGHT);
    rateView = [[DYRateView alloc] initWithFrame:rateFrame];
    [rateView setRate:0];
    [rateView setEditable:YES];
    [rateView setAlignment:RateViewAlignmentLeft];
    [vwRateView addSubview:rateView];
    
    [self loadProfileInformation:rankedUserID];

}

- (void)loadProfileInformation:(NSString*)userID
{
    
    NSString * profileUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getProfileByUser";
    profileUrl = [NSString stringWithFormat:@"%@&user_id=%@", profileUrl, userID];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:profileUrl :^(NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSData *responseData = data;
        if (responseData == nil) {
            return;
        }
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"result string: %@", string);
        
        NSError *error;
        NSDictionary *jsonDict = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error] objectAtIndex:0];
        NSString * fullname = [jsonDict objectForKey:@"fullname"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([fullname isEqualToString:@""] == YES) {
                //                [Common showAlert:@"תקלה" Message:@"טעינת נתוני משתמש נכשלה" ButtonName:@"אשר"];
                
            }
            else
            {
                NSString *imageUrl = [jsonDict objectForKey:@"image_url"];
                NSString *avg_rank = [jsonDict objectForKey:@"avg_rank"];
                CGFloat rank = [avg_rank floatValue];
                
                // text and phone
                [self.lblFullname setText:fullname];
                [rateView setRate:rank];
                
                if (imageUrl != nil && [imageUrl isEqualToString:@""] == NO)
                {
                    [imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                    
                    imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2.0f;
                    imgAvatar.clipsToBounds = YES;
                    imgAvatar.layer.borderColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f].CGColor;
                    imgAvatar.layer.borderWidth = 5.0f;
                }
            }
        });
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *imgUrl = [preferences objectForKey:@"image_url"];
    
    // Profile picture
    if (imgUrl != nil && [imgUrl isEqualToString:@""] == NO)
    {
        [imgAvatar sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2.0f;
            imgAvatar.clipsToBounds = YES;
            imgAvatar.layer.borderColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f].CGColor;
            imgAvatar.layer.borderWidth = 5.0f;
            
        }];
    }
     */
}

#pragma mark - IBAction
- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSend:(id)sender
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *ranker_id = [preferences objectForKey:@"user_id"];
    
    float rate = rateView.rate;
    
    NSString *rankUrl = @"http://travelmakerdata.co.nf/server/index.php?action=setRankingForUser";
    rankUrl = [NSString stringWithFormat:@"%@&ranker_id=%@", rankUrl, ranker_id];
    rankUrl = [NSString stringWithFormat:@"%@&user_id=%@", rankUrl, rankedUserID];
    rankUrl = [NSString stringWithFormat:@"%@&rank=%f", rankUrl, rate];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DCDefines getHttpAsyncResponse:rankUrl :^(NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSData *responseData = data;
        if (responseData == nil) {
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"result string: %@", string);
        
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSString * status = [jsonDict objectForKey:@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([status isEqualToString:@"done"] == YES) {
                [Common showAlert:@"הפעולה בוצעה בהצלחה" Message:@"הדירוג הושלם בהצלחה" ButtonName:@"אשר"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [Common showAlert:@"דירוג לא בוצע" Message:@"כבר ביצעת דירוג בעבר למשתמש זה. תודה רבה!" ButtonName:@"אשר"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
        
    }];

    
}

@end
