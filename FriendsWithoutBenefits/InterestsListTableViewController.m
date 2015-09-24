//
//  InterestsListTableViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "InterestsListTableViewController.h"
#import "Interest.h"
#import "ParseService.h"

@interface InterestsListTableViewController ()

@property (strong, nonatomic) NSArray *interests;
@property (strong, nonatomic) NSArray *userInterests;
@property (strong, nonatomic) NSString *className;

@end

@implementation InterestsListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom the table
    
    // The className to query on
    self.className = @"Interest";
    
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"name";
    
    // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
    // self.imageKey = @"image";
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 25;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  User *currentUser = [User currentUser];
  
  [currentUser userInterests:^(NSArray *interests) {
    self.userInterests = interests;
    [self.tableView reloadData];
  }];
  
  
  
  
    [ParseService queryForInterests:^(NSArray *interests) {
      self.interests = interests;
      [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell" forIndexPath:indexPath];
  
  Interest *currentInterest = self.interests[indexPath.row];
  
  if ([self.userInterests containsObject:currentInterest]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.tag = 1;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tag = 0;
  }
  
  cell.textLabel.text = currentInterest.name;
  
    return cell;
}

#pragma mark - PFQueryTableViewController

 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.

 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 [query orderByDescending:@"name"];
 
 return query;
 }


#pragma mark - UITableView Selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  
  Interest *currentInterest = self.interests[indexPath.row];

  if (cell.accessoryType) {
    NSLog(@"Cell has an accessory");
    cell.accessoryType = UITableViewCellAccessoryNone;
    [ParseService removeInterestFromCurrentUser:currentInterest];
  } else {
    NSLog(@"Cell has no accessory");
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [ParseService addInterestToCurrentUser:currentInterest];
  }
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
