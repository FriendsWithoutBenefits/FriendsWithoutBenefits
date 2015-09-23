//
//  ActivityManager.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Activity.h"
#import "User.h"

@interface ActivityManager : PFObject <PFSubclassing>

@property (strong, nonatomic) NSMutableArray *userOwnedActivities;
@property (strong, nonatomic) NSMutableArray *userSelectedActivities;
@property (strong, nonatomic) 

@end
