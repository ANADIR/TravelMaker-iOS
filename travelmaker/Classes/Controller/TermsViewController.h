//
//  TermsViewController.h
//  Travel Maker
//
//  Created by developer on 1/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "SuperViewController.h"

@interface TermsViewController : SuperViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webService;

- (IBAction)clickBack:(id)sender;


@end
