//
//  CreateActivityStaticTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/24/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "CreateActivityStaticTableViewController.h"
#import "CenterPinMapViewController.h"
#import <MapKit/MapKit.h>
#import "User.h"
#import "Activity.h"
#import "UIKit/UIKit.h"


@interface CreateActivityStaticTableViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *activityDatePicker;
@property (weak, nonatomic) IBOutlet MKMapView *activityLocationMapView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Activity *activity;
//Create array to keep track of attendees

@end

@implementation CreateActivityStaticTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateNotificationHandler:) name:@"CoordinateNotification" object:nil];
  self.user = (User *)[User currentUser];
  self.activityDatePicker.datePickerMode = UIDatePickerModeDate;
  self.activity = [[Activity alloc] init];
  self.activityTitleTextField.delegate = self;
  self.activityDescriptionTextView.delegate = self;
  [self setUpTextFields];
}

- (void)setUpTextFields {
  self.activityTitleTextField.placeholder = @"i.e. Mad Decent Block Party!";
  self.activityDescriptionTextView.text = @"    It's time for round two of the Mad Decent Block Party in Eugene! Love trap music and obnoxious loud EDM? Join this activity and let's all have a great time. I mean guess Major Lazer is awesome right?";
  
}
- (IBAction)chooseLocationButtonPressed:(UIButton *)sender {
  CenterPinMapViewController *centerPinMap = [[CenterPinMapViewController alloc] init];
  centerPinMap.activity = self.activity;
  [self performSegueWithIdentifier:@"ShowLocationMap" sender:sender];
}

-(void)coordinateNotificationHandler: (NSNotification *) notification {
  //Add region
  PFGeoPoint *geoPoint = notification.userInfo[@"Coordinate"];
  self.activity.location = geoPoint;
}

-(void)pickActivityLocation {
  //Use map or however else to get activity coordinate (idk about address for now)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createActivityButton:(UIButton *)sender {
  self.activity.title = self.activityTitleTextField.text;
  self.activity.about = self.activityDescriptionTextView.text;
  self.activity.date = self.activityDatePicker.date;
  self.activity.owner = self.user;
  
  PFRelation *newRelation = [self.activity relationForKey:@"attendees"];
  [newRelation addObject:self.user];
  
  [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    User *currentUser = [User currentUser];
    
    PFRelation *addActivity = [currentUser relationForKey:@"joinedActivities"];
    [addActivity addObject:self.activity];
    [currentUser saveInBackground];
  }];
  [self.navigationController popViewControllerAnimated:true];
  //Set interest
  //Set location
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.activityDescriptionTextView endEditing:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
