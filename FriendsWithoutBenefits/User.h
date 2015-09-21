//
//  User.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFObject<PFSubclassing>

@property (strong,nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) UIImage *profilePicture;
//Interests, what kind of data structure is best?
@property (strong, nonatomic) NSMutableArray *interests;
@property (strong, nonatomic) NSMutableArray *peopleMatched;
@property (strong, nonatomic) NSMutableArray *peopleNotMatched;
//Location property

@property (nonatomic) BOOL *isOnline;
@property (strong,nonatomic) PFUser *user;

+ (NSString *)parseClassName;

@end
