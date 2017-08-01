//
//  MessageCell.h
//  Travel Maker
//
//  Created by developer on 1/10/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface MessageCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;

@end
