//
//  TrafficViewCell.h
//  Travel Maker
//
//  Created by developer on 12/9/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblPassenger;
@property (nonatomic, weak) IBOutlet UILabel *lblHour;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@property (nonatomic, weak) IBOutlet UILabel *lblAreaOrDest;
@property (nonatomic, weak) IBOutlet UILabel *lblPlaceStart;

@property (nonatomic, weak) IBOutlet UIView *vwContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableCellAreaWidth;

@end
