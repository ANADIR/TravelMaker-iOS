//
//  MyMessageController.h
//  Travel Maker
//
//  Created by developer on 12/29/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "SuperViewController.h"
#import <SWTableViewCell.h>

@interface MyMessageController : SuperViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblMessage;

@property (strong, nonatomic) NSMutableArray *arrayMessageData;

- (IBAction)clickBack:(id)sender;

@end
