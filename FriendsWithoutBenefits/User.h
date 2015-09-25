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
@property (strong, nonatomic, readonly) PFRelation *interests;
@property (strong, nonatomic, readonly) PFRelation *peopleMatched;
@property (strong, nonatomic, readonly) PFRelation *peopleNotMatched;
@property (strong, nonatomic, readonly) PFRelation *joinedActivities;
@property (strong, nonatomic) PFFile *profileImageFile;
//Location property

@property (nonatomic) BOOL *isOnline;

-(NSString *)fullName;
-(void)userInterests:(void(^)(NSArray *interests))completion;
-(void)userJoinedActivities:(void(^)(NSArray *activities))completion;

@end
