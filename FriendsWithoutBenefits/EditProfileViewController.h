//
//  EditProfileViewController.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) User *editUser;

@end
