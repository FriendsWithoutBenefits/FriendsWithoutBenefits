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
@property (strong, nonatomic) Activity *selectedActivity;
@property (strong, nonatomic) User *user;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = (User *)[PFUser currentUser];
  if (![self.selectedActivity.attendees containsObject:[User currentUser]]) {
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
  self.numberOfAttendees.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.selectedActivity.attendees.count];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonPressed:(UIButton *)sender {
  if (![self.selectedActivity.attendees containsObject:[User currentUser]]) {
    [ParseService addUserToActivity:self.selectedActivity];
    //save to parse
    [self.navigationController popViewControllerAnimated:true];
  } else {
    [ParseService removeUserFromActivity:self.selectedActivity];
    //save to parse
    [self.navigationController popViewControllerAnimated:true];
  }
  //If the array does have this user already, just pop off vc, else add then pop off.
  // Join the activity (add user to activity) array.
  // Add activity to user joined array
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
