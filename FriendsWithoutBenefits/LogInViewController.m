//
//  LogInViewController.m
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "LogInViewController.h"
#import "LayerService.h"
#import <LayerKit/LayerKit.h>

@interface LogInViewController ()

@property(strong,nonatomic) UIImageView *backgroundImageView;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc]init];
  
    self.delegate = self;
    self.signUpController.delegate = self;
    self.signUpController = signUpViewController;
  
    // loginViewController customized template
    UILabel* logInLabel = [[UILabel alloc]init];
    logInLabel.text = @"FWOB";
    logInLabel.textColor = [UIColor whiteColor];
    logInLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:65.0];
    logInLabel.shadowColor = [UIColor lightGrayColor];
    logInLabel.shadowOffset = CGSizeMake(1, 1);
    self.logInView.logo = logInLabel;
  
    // setupbackground image for Log In
    UIImage *backgroundImage = [UIImage imageNamed:@"launch_bg"];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];

    [self.logInView insertSubview:self.backgroundImageView atIndex:0];
  
    // signUpViewController customized template
    UILabel* signUpLabel = [[UILabel alloc]init];
    signUpLabel.text = @"FWOB";
    signUpLabel.textColor = [UIColor whiteColor];
    signUpLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:65.0];
    signUpLabel.shadowColor = [UIColor lightGrayColor];
    signUpLabel.shadowOffset = CGSizeMake(1, 1);
    signUpViewController.signUpView.logo = signUpLabel;
  
//  [signUpViewController.signUpView insertSubview:self.backgroundImageView atIndex:0];
  
  
 }

- (void)viewWillAppear:(BOOL)animated{
    self.fields = (PFLogInFieldsUsernameAndPassword
                   | PFLogInFieldsLogInButton
                   | PFLogInFieldsSignUpButton
                   | PFLogInFieldsPasswordForgotten);
}

- (void)viewWillLayoutSubviews{
    // position the logo
    // position logo at top with larger frame
//  logInView!.logo!.sizeToFit()
//  let logoFrame = logInView!.logo!.frame
//  logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
  [self.logInView.logo sizeToFit];
//
CGRect logoFrame = self.logInView.logo.frame;
//  self.logInView.logo.frame = CGRectMake(logoFrame.origin.x, self.logInView.usernameField.frame.origin - logoFrame.size.height - 16, self.logInView.size.width, logoFrame.size.height);

  self.backgroundImageView.frame = CGRectMake(0, 0, self.logInView.frame.size.height, self.logInView.frame.size.width);
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse Login Delegate Method:

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
  // Check if both fields are completed
  if (username && password && username.length != 0 && password.length != 0) {
    return YES; // Begin login process
  }

  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"All fields requred"
                                                                 message:@"Please fill out all fields"
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
  
  return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
        [LayerService.sharedService loginLayer];
  
  //Register for Push
  //Notifcation Settings
  UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                  UIUserNotificationTypeBadge |
                                                  UIUserNotificationTypeSound);
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                           categories:nil];
  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
  
  [self performSegueWithIdentifier:@"showTabBarSeque" sender:self];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  NSLog(@"Failed to log in...");
}

#pragma mark - Parse SignUpViewController Delegate Method:

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
  BOOL informationComplete = YES;
  
  
  return informationComplete;
  
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [signUpController dismissViewControllerAnimated:true completion:^{
      [LayerService.sharedService loginLayer];
      
      //Register for Push
      //Notifcation Settings
      UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                      UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound);
      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                               categories:nil];
      [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
      [[UIApplication sharedApplication] registerForRemoteNotifications];
      
      [self performSegueWithIdentifier:@"showTabBarSeque" sender:self];
    }];
}


// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
  NSLog(@"User dismissed the signUpViewController");
  // Direct the user the rootView Controller
}


@end
