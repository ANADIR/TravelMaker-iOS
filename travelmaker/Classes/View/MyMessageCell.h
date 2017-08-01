//
//  MyMessageCell.h
//  Travel Maker
//
//  Created by developer on 12/29/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface MyMessageCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblLocation;
@property (nonatomic, weak) IBOutlet UILabel *lblDateStart;

@end
