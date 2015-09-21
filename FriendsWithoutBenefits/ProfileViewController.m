//
//  ProfileViewController.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "EditProfileViewController.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editNavButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchProfile {
  //Download User Information from Parse
  //Parser service for user info
}

-(void)setUpProfile {
  //Populate VC's fields
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowEditViewController"]) {
    EditProfileViewController *editProfileViewController = [segue destinationViewController];
    self.firstNameLabel.text = @"Cat";
    self.ageLabel.text = @"123";
    editProfileViewController.editUser = self.user;
    [editProfileViewController.editNameTextField setPlaceholder:self.firstNameLabel.text];
    editProfileViewController.editAgeTextField.placeholder = self.ageLabel.text;
    editProfileViewController.editAboutTextView.text = self.aboutTextView.text;
  }
}

- (IBAction)editNavButtonPushed:(UIBarButtonItem *)sender {
  [self performSegueWithIdentifier:@"ShowEditViewController" sender:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
