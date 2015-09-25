//
//  ProfileTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/25/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <Parse/Parse.h>

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  User *currentUser = [User currentUser];
  
  PFFile *userImageFile = currentUser.profileImageFile;
  [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
    if (!error) {
      UIImage *image = [UIImage imageWithData:imageData];
      self.profileImage.image = image;
    }
  }];
  
  self.nameLabel.text = currentUser.name;
  self.ageLabel.text = [currentUser.age stringValue];
  self.aboutTextLabel.text = currentUser.aboutMe;
  
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
