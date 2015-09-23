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
  
  cell.textLabel.text = currentInterest.name;
  
    return cell;
}

#pragma mark - PFQueryTableViewController

 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.

 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 // If Pull To Refresh is enabled, query against the network by default.
 
 [query orderByDescending:@"name"];
 
 return query;
 }


#pragma mark - UITableView Selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  
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
