//
//  MessageController.h
//  Travel Maker
//
//  Created by developer on 1/4/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"
#import <SWTableViewCell.h>

@interface MessageController : SuperViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblMessage;

@property (strong, nonatomic) NSMutableArray *arrayMessageData;

- (IBAction)clickBack:(id)sender;


@end
