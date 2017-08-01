//
//  TermsViewController.m
//  Travel Maker
//
//  Created by developer on 1/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "TermsViewController.h"

@implementation TermsViewController

@synthesize webService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"service" ofType:@"htm"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webService loadHTMLString:htmlString baseURL:nil];
    
    [webService setBackgroundColor:[UIColor clearColor]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction
- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webService.frame;
    frame.size.height = 1;
    webService.frame = frame;
    CGSize fittingSize = [webService sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webService.frame = frame;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
