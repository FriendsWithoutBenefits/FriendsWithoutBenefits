//
//  User.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <Atlas/Atlas.h>

@interface User : PFUser <PFSubclassing, ATLParticipant>

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
@property (strong, nonatomic) PFFile *userProfileImageFile;
//Location property

@property (nonatomic) BOOL *isOnline;

-(NSString *)fullName;

@end
