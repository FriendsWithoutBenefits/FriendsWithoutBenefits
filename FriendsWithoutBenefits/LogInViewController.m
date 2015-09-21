//
//  LogInViewController.m
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 }

- (void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (![PFUser currentUser]) { // No user logged in
                               // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
   
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
  }
  
  if ([PFUser currentUser]) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logged Out" message:@"Automactic Logout" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [PFUser logOut];
  }
  


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
  
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"Please fill out all fields"
                                message:@"Make sure you fill out all of the information!"
                                preferredStyle:UIAlertControllerStyleAlert];
  
  [self presentViewController:alert animated:YES completion:nil];
  return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Parse SignUpViewController Delegate Method:

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
  BOOL informationComplete = YES;
  
  // loop through all of the submitted data
  for (id key in info) {
    NSString *field = [info objectForKey:key];
    if (!field || field.length == 0) { // check completion
      informationComplete = NO;
      break;
    }
  }
  
  // Display an alert if a field wasn't completed
  UIAlertController * alert=  [UIAlertController
                                alertControllerWithTitle:@"Please fill out all fields"
                                message:@"Make sure you fill out all of the information!"
                                preferredStyle:UIAlertControllerStyleAlert];
  
  [self presentViewController:alert animated:YES completion:nil];
  
  return informationComplete;
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
  [self presentViewController:signUpController animated:YES completion:nil]; // Dismiss the PFSignUpViewController
  // Direct the user to rootViewController here
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
  NSLog(@"Failed to sign up...");
  //present the loginView Controller again
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
  NSLog(@"User dismissed the signUpViewController");
  // Direct the user the rootView Controller
}

@end
