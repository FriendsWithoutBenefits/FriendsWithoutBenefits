//
//  User.h
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFObject<PFSubclassing>

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) PFUser *user;

@end
