//
//  TrafficViewCell.m
//  Travel Maker
//
//  Created by developer on 12/9/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "TrafficViewCell.h"

@implementation TrafficViewCell

@synthesize TableCellAreaWidth;

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 8;
    frame.origin.y += 4;
    frame.size.width -= 2 * 8;
    frame.size.height -= 4;
    
    TableCellAreaWidth.constant = (frame.size.width - 160 - 16) / 2.0f;
    [self updateConstraints];
    
    [super setFrame:frame];
}

@end
