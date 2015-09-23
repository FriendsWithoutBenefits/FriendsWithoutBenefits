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
#import <Parse/Parse.h>
#import "ParseService.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) PFObject *currentUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editNavButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.user = (User*)[PFUser currentUser];

  NSLog(@"%@", self.user);
  if (self.user) {
    
//    PFFile *userImageFile = self.user.userProfileImageFile;
//    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//      if (!error) {
//        UIImage *image = [UIImage imageWithData:imageData];
//        self.profilePicture.image = image;
//      }
//    }];

    self.title = [@"Hello " stringByAppendingString:self.user.username];
    self.firstNameLabel.text = self.user.username;
    if (!self.user.age) {
      self.ageLabel.text = @"What's your age?";
    }
    self.ageLabel.text = [self.user.age stringValue];
    self.aboutTextView.text = self.user.aboutMe;
  }
  

}

//- (void)viewDidAppear:(BOOL)animated{
//  [super viewDidAppear:YES];
//  
//
//  
//}

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
//    self.firstNameLabel.text = @"Cat";
//    self.ageLabel.text = @"123";
    editProfileViewController.editUser = self.user;
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
