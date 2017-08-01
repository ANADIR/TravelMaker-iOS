//
//  RightPaddingTextField.m
//  Travel Maker
//
//  Created by developer on 12/17/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "RightPaddingTextField.h"

@implementation RightPaddingTextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 20, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 20, 0);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:50.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f]
                                  };
    
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2, rect.size.width, rect.size.height);
    [[self placeholder] drawInRect:placeholderRect withAttributes:attributes];
}

@end
