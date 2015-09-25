//
//  CustomLoginViewViewController.m
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/24/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "CustomLoginViewViewController.h"
#import "LayerService.h"
#import <LayerKit/LayerKit.h>

@interface CustomLoginViewViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property(strong,nonatomic) PFLogInViewController *loginVC;

@end

@implementation CustomLoginViewViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc]init];
  
//  self.delegate = self;
//  self.signUpController.delegate = self;
//  self.signUpController = signUpViewController;
//  
//  // loginViewController customized template
//  UILabel* logInLabel = [[UILabel alloc]init];
//  logInLabel.text = @"FWOB";
//  self.logInView.logo = logInLabel;
//  
//  // signUpViewController customized template
//  UILabel* signUpLabel = [[UILabel alloc]init];
//  signUpLabel.text = @"FWOB";
//  signUpViewController.signUpView.logo = signUpLabel;
  
  
}
//
//- (void)viewDidAppear:(BOOL)animated{
//  [super viewDidAppear:YES];
//}

- (void)viewWillAppear:(BOOL)animated{
  
  // Put this block of code in if condition if PF user is not signed up
  self.loginVC = [[PFLogInViewController alloc]init];
  self.loginVC.delegate = self;
  self.loginVC.signUpController.delegate = self;
  [self presentViewController:self.loginVC animated:false completion:nil];
  
  self.loginVC.fields = (PFLogInFieldsUsernameAndPassword
                 | PFLogInFieldsLogInButton
                 | PFLogInFieldsSignUpButton
                 | PFLogInFieldsPasswordForgotten);
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
    [self performSegueWithIdentifier:@"showTabBarSeque" sender:self];
  }];
}


// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
  NSLog(@"User dismissed the signUpViewController");
  // Direct the user the rootView Controller
}



@end
