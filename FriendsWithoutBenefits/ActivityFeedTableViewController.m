//
//  ActivityFeedTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ActivityFeedTableViewController.h"
#import "UserActivityFeedTableViewController.h"
#import "ActivityDetailViewController.h"
#import "CreateActivityStaticTableViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Activity.h"
#import "ActivityCell.h"

@interface ActivityFeedTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myActivities;
@property (strong, nonatomic) NSArray *joinedActivities;
@property (strong, nonatomic) NSArray *nearbyActivities;
@property (strong, nonatomic) User *user;

@end

@implementation ActivityFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self queryForActivities];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) setUpUserActivities {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryForActivities {
  //Query for all user created activities.
  PFQuery *myActivityQuery = [PFQuery queryWithClassName:@"Activity"];
  [myActivityQuery whereKey:@"owner" equalTo:[User currentUser]];
  [myActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *myActivity, NSError *error) {
    //Loop through reminders and create annotations.
    self.myActivities = myActivity;
    [self.tableView reloadData];
  }];
  
//  //Use query all activities by the joined property which has the value of true
//  PFQuery *joinedActivityQuery = [Activity query];
//  [joinedActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *joinedActivity, NSError *error) {
//    //Loop through reminders and create annotations.
//    self.joinedActivities = joinedActivity;
//    
//  }];
//  
//  PFQuery *nearbyActivityQuery = [Activity query];
//  [nearbyActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *nearbyActivity, NSError *error) {
//    //Loop through reminders and create annotations.
//    self.nearbyActivities = nearbyActivity;
//    
//  }];
//  
}

- (IBAction)userActivitiesButtonPushed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ShowActivityCreator" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowActivityCreator"]) {
    CreateActivityStaticTableViewController *activityCreator = [segue destinationViewController];
  }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
  switch (section) {
    case 0:
      return self.myActivities.count; //Return number of activities you created
      break;
    case 1:
      return 2; //Return number of activities you joined
      break;
    default:
      return 3; //Query and return nearby activities
      break;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *sectionName;
  switch (section) {
    case 0:
      sectionName = @"My Activities";
      break;
    case 1:
      sectionName = @"Joined Activities";
      break;
    default:
      sectionName = @"Nearby Activities";
      break;
  }
  return sectionName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
  static NSString *CellIdentifier = @"ActivityCell";
  
  ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  if (indexPath.section == 0) { //My Activity Array (Find all activities by owner)
    Activity *activity = [self.myActivities objectAtIndex:indexPath.row];
    NSString *title = activity.title;
    cell.activityTitle.text = title;
//    ObjectData *theCellData = [array1 objectAtIndex:indexPath.row];
//    NSString *cellValue =theCellData.category;
//    cell.textLabel.text = cellValue;
  }
  else if (indexPath.section == 1) { //My Activity (Find all activities that you 'joined'
//    ObjectData *theCellData = [array2 objectAtIndex:indexPath.row];
//    NSString *cellValue =theCellData.category;
//    cell.textLabel.text = cellValue;
  } else { //Query all Activity objects within a certain distance from your current location.
//    ObjectData *theCellData = [array2 objectAtIndex:indexPath.row];
//    NSString *cellValue =theCellData.category;
//    cell.textLabel.text = cellValue;
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //Pass reference of activity to next VC
  ActivityDetailViewController *activityDetailViewController = [[ActivityDetailViewController alloc] init];
  //activityDetailViewController.selectedActivity = //Activity at indexPath;
  [self performSegueWithIdentifier:@"ShowActivityDetail" sender:nil];
}



@end
