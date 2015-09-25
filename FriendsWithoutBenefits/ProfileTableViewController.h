//
//  ProfileTableViewController.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/25/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileTableViewController : UITableViewController

@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutTextLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
