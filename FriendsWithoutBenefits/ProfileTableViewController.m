//
//  ProfileTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/25/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <Parse/Parse.h>
#import "InterestCell.h"
#import "Interest.h"
#import "EditProfileTableViewController.h"

@interface ProfileTableViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *interests;
@property (strong, nonatomic) User *user;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  User *currentUser = [User currentUser];
  self.user = currentUser;
  NSLog(@"Current User Name: %@", currentUser.interests);
  
  [currentUser userInterests:^(NSArray *interests) {
    self.interests = interests;
    [self.collectionView reloadData];
  }];
  
  
  PFFile *userImageFile = currentUser.profileImageFile;
  [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
    if (!error) {
      UIImage *image = [UIImage imageWithData:imageData];
      self.profileImage.image = image;
      [self.tableView reloadData];
    }
  }];
  
  self.nameLabel.text = currentUser.username;
  self.ageLabel.text = [currentUser.age stringValue];
  self.aboutTextLabel.text = currentUser.aboutMe;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.interests.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  Interest *currentInterest = self.interests[indexPath.row];
  
  InterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
  
  cell.interestLabel.text = currentInterest.name;
  
  return cell;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
   if ([segue.identifier isEqualToString:@"ShowEditViewController"]) {
     EditProfileTableViewController *editProfileViewController = [segue destinationViewController];
     //    self.firstNameLabel.text = @"Cat";
     //    self.ageLabel.text = @"123";
     editProfileViewController.editUser = self.user;
   }
 }


@end
