//
//  ProfileController.m
//  Travel Maker
//
//  Created by developer on 1/6/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "ProfileController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation ProfileController

@synthesize imgAvatar, imgEditName, imgEditPhone;
@synthesize txtPhone, txtFullname;
@synthesize vwRateView;
@synthesize btnEdit;

#define RATEVIEW_WIDTH  90
#define RATEVIEW_HEIGHT 20

bool isEditable = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadProfileInformation];
    
    CGRect frame = vwRateView.frame;
    CGRect rateFrame = CGRectMake((frame.size.width - RATEVIEW_WIDTH) / 2.0,
                                  (frame.size.height - RATEVIEW_HEIGHT) / 2.0,
                                  RATEVIEW_WIDTH,
                                  RATEVIEW_HEIGHT);
    rateView = [[DYRateView alloc] initWithFrame:rateFrame];
    [rateView setRate:0.0f];
    [rateView setAlignment:RateViewAlignmentLeft];
    [vwRateView addSubview:rateView];
    
    
    isEditable = NO;
    [txtFullname setEnabled:isEditable];
    [txtPhone setEnabled:isEditable];
    [imgEditName setHidden:!isEditable];
    [imgEditPhone setHidden:!isEditable];
    
    imgAvatar.userInteractionEnabled = YES;
    // Add tapGesture
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAvatar)];
    tapAvatar.delegate = self;
    [imgAvatar addGestureRecognizer:tapAvatar];


}

- (void)loadProfileInformation
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];

    NSString * profileUrl = @"http://travelmakerdata.co.nf/server/index.php?action=getProfileByUser";
    profileUrl = [NSString stringWithFormat:@"%@&user_id=%@", profileUrl, user_id];
    
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
                NSString *cellPhone = [jsonDict objectForKey:@"cellphone"];
                NSString *avg_rank = [jsonDict objectForKey:@"avg_rank"];
                CGFloat rank = [avg_rank floatValue];
                
                // text and phone
                [txtFullname setText:fullname];
                [txtPhone setText:cellPhone];
                [rateView setRate:rank];
                
//                if (imageUrl != nil && [imageUrl isEqualToString:@"none"] == NO)
//                {
//                    [imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//                    
//                    imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2.0f;
//                    imgAvatar.clipsToBounds = YES;
//                    imgAvatar.layer.borderColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f].CGColor;
//                    imgAvatar.layer.borderWidth = 5.0f;
//                }
//                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
//                NSString *imgUrl = [preferences objectForKey:@"image_url"];
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

#pragma mark - IBAction
- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickEdit:(id)sender
{
    isEditable = !isEditable;
    
    [txtFullname setEnabled:isEditable];
    [txtPhone setEnabled:isEditable];
    [imgEditName setHidden:!isEditable];
    [imgEditPhone setHidden:!isEditable];

    if (isEditable == YES)
        [btnEdit setTitle:@"שמור" forState:UIControlStateNormal];
    else
        [btnEdit setTitle:@"ערוך" forState:UIControlStateNormal];
 
    // save
    if (isEditable == NO)
    {
        NSString *new_name = [txtFullname text];
        NSString *new_phone = [txtPhone text];
        
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        NSString *fullname = [preferences objectForKey:@"fullname"];
        NSString *phone = [preferences objectForKey:@"cellphone"];

        if ([new_name isEqualToString:fullname] == NO || [new_phone isEqualToString:phone] == NO)
        {
            NSString *user_id = [preferences objectForKey:@"user_id"];
            
            NSString *updateProfileUrl = @"http://travelmakerdata.co.nf/server/index.php?action=updateProfile";
            updateProfileUrl = [NSString stringWithFormat:@"%@&user_id=%@", updateProfileUrl, user_id];
            updateProfileUrl = [NSString stringWithFormat:@"%@&fullname=%@", updateProfileUrl, new_name];
            updateProfileUrl = [NSString stringWithFormat:@"%@&cellphone=%@", updateProfileUrl, new_phone];
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DCDefines getHttpAsyncResponse:updateProfileUrl :^(NSData *data, NSError *connectionError) {
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
                        [Common showAlert:@"Success" Message:@"פרטי פרופיל עודכנו בהצלחה" ButtonName:@"אשר"];
                        
                        // save
                        [preferences setObject:new_name forKey:@"fullname"];
                        [preferences setObject:new_phone forKey:@"cellphone"];
                        [preferences synchronize];
                    }
                    else
                    {
                        [Common showAlert:@"תקלה" Message:@"פרופיל לא עודכן בשל תקלה" ButtonName:@"אשר"];
                    }
                });
            }];
        }
    }
}

- (void)handleTapAvatar
{
    UIImagePickerController *mImagePicker = [[UIImagePickerController alloc] init];
    
#if TARGET_IPHONE_SIMULATOR
    mImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    mImagePicker.delegate = self;
    
    [self presentViewController:mImagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
 
    [self uploadImageToServer:image];
}

- (void)uploadImageToServer:(UIImage *)image
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    
    NSString *uploadUrl = @"http://travelmakerdata.co.nf/server/actions/upload_image.php";

    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"user_id"];
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:@"image.jpg"
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Sucess uploading image: %@", responseObject);

        NSString *imageUrl = [responseObject objectForKey:@"image_url"];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setObject:imageUrl forKey:@"image_url"];
        [preferences synchronize];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [imgAvatar setImage:image];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed uploading image : %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

@end
