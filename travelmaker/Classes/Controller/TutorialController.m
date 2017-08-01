//
//  TutorialController.m
//  Travel Maker
//
//  Created by developer on 12/4/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "TutorialController.h"
#import "MFSideMenu.h"
#import "TrafficController.h"
#import "MenuController.h"
#import "AppDelegate.h"

@implementation TutorialController

@synthesize imgTutorial;
@synthesize lblTutorial;

int current_tutorial;
int previous_tutorial;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft ];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight ];
    [self.view addGestureRecognizer:swipeRight];
    
    current_tutorial = 1;
    previous_tutorial = current_tutorial;
    
    // auto login
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [preferences objectForKey:@"user_id"];
    NSString *email = [preferences objectForKey:@"email"];
    if (user_id != nil && email != nil)
        [self gotoMainScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMainScreen
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    TrafficController *trafficController = [self.storyboard instantiateViewControllerWithIdentifier:@"trafficVC"];
    MenuController *menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:trafficController
                                                    leftMenuViewController:menuController
                                                    rightMenuViewController:nil];
    
    [trafficController setMenuController:container];
    [menuController setMenuController:container];
    
    delegate.window.rootViewController = container;
    [delegate.window makeKeyAndVisible];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)swipedRight:(UISwipeGestureRecognizer *)recognizer
{
    if (current_tutorial == 1)
        return;
    
    previous_tutorial = current_tutorial;
    current_tutorial --;
    [self updateTutorialView:current_tutorial];
}

- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (current_tutorial == 3)
        return;

    previous_tutorial = current_tutorial;
    current_tutorial ++;
    [self updateTutorialView:current_tutorial];
}

- (void)updateTutorialView:(int) tutorial
{
    UIImage *newImage = nil;
    NSString *newText = nil;
    
    switch (tutorial)
    {
        case 1:
            newImage = [UIImage imageNamed:@"Tutorial02"];
            newText = @"זירת המסחר - כאן תוכל לצפות או להוסיף נסיעות";
            break;
        case 2:
            newImage = [UIImage imageNamed:@"Tutorial01"];
            newText = @"פרטי הנסיעה";
            break;
        case 3:
            newImage = [UIImage imageNamed:@"Tutorial03"];
            newText = @"סגירת הנסיעות ודרכי תקשורת";
            break;
        default:
            newImage = [UIImage imageNamed:@"Tutorial01"];
            newText = @"פרטי הנסיעה";
            break;
    }
    
//    [UIView transitionWithView:self.view
//                      duration:.3f
//                       options:UIViewAnimationOption
//                    animations:^{
//                        imgTutorial.image = newImage;
//                    } completion:nil];
    imgTutorial.image = newImage;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    if (previous_tutorial > current_tutorial)
        transition.subtype = kCATransitionFromLeft;
    else
        transition.subtype = kCATransitionFromRight;
    
    [imgTutorial.layer addAnimation:transition forKey:nil];
    
    [lblTutorial setText:newText];
}
@end
