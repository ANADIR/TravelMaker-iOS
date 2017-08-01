//
//  AboutServiceController.m
//  Travel Maker
//
//  Created by developer on 1/5/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "AboutServiceController.h"

@implementation AboutServiceController

@synthesize webService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@"htm"];
    [webService loadRequest:[NSURLRequest requestWithURL:url]];
    [webService setBackgroundColor:[UIColor whiteColor]];
    
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
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = theWebView.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    theWebView.scrollView.zoomScale = rw;
//
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    CGRect frame = webService.frame;
    frame.size.height = 1;
    webService.frame = frame;
    CGSize fittingSize = [webService sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webService.frame = frame;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
