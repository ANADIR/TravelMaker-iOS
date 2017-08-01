//
//  PaddingTextField.m
//  Owl Eyes
//
//  Created by developer on 11/13/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "PaddingTextField.h"

@implementation PaddingTextField

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
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor]
                                  };
    
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2, rect.size.width, rect.size.height);
    [[self placeholder] drawInRect:placeholderRect withAttributes:attributes];
}

@end
