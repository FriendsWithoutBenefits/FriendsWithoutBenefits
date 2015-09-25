//
//  ActivityDetailViewController.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/24/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "Activity.h"
#import "User.h"
#import "Parse/Parse.h"
#import "ParseService.h"


@interface ActivityDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAttendees;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *userActivityRelations;
@property (strong, nonatomic) NSArray *userActivities;
@property (strong, nonatomic) NSArray *activityJoinedUsers;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User currentUser];
  [self fetchRelations];
  if (![self.activityJoinedUsers containsObject:self.user]) {
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
  } else {
    [self.joinButton setTitle:@"Leave Activity" forState:UIControlStateNormal];
  }
  
  //load up activity

    // Do any additional setup after loading the view.
}

- (void)setUpDetailPage {
  self.activityTitleLabel.text = self.selectedActivity.title;
  //ToString from date to string
 // self.activityDateLabel.text = self.selectedActivity.date;
  //self.time
  self.activityDescriptionTextView.text = self.selectedActivity.description;
  self.numberOfAttendees.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.userActivityRelations.count];
  
}

- (void)fetchRelations {
  User *user = [User currentUser];
  
  [user userJoinedActivities:^(NSArray *activities) {
    self.userActivityRelations = activities; //Returns user's joined activities
  }];
  
  [self.selectedActivity usersInActivity:^(NSArray *users) {
    self.activityJoinedUsers = users; //Returns activity's joined users
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonPressed:(UIButton *)sender {
  if (![self.activityJoinedUsers containsObject:self.user]) {
    [ParseService addUserToActivity:self.selectedActivity];
  } else {
    [ParseService removeUserFromActivity:self.selectedActivity];
  }
  
//  [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    if (error) {
//      // There was an error
//    } else {
//      // objects has all the Posts the current user liked.
//      if (![objects containsObject:self.user]) {
//        [ParseService addUserToActivity:self.selectedActivity];
//        [self.navigationController popViewControllerAnimated:true];
//      } else {
//        [ParseService removeUserFromActivity:self.selectedActivity];
//        [self.navigationController popViewControllerAnimated:true];
//      }
//    }
//  }];
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
