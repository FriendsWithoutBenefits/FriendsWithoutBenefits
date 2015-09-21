//
//  User.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "User.h"

@interface User()
//Gender;
//TagLine;
@property (strong, nonatomic) NSString *userName;
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
//
@property (nonatomic) BOOL *isOnline;

@end

@implementation User
-(NSString *)getUserName {
  return self.userName;
}

-(void)setFirstName:(NSString *)firstName {
  self.firstName = firstName;
}

-(void)setLastName:(NSString *)lastName {
  self.lastName = lastName;
}

-(NSString *)getFullName {
  NSString *name = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
  return name;
}

-(void)setAge:(NSNumber *)age {
  self.age = age;
}

-(NSNumber *)getAge {
  return self.age;
}

-(void)setAboutMe:(NSString *)aboutMe {
  self.aboutMe = aboutMe;
}

-(void)setProfilePicture:(UIImage *)profilePicture {
  self.profilePicture = profilePicture;
}

-(UIImage *)getProfilePicture {
  return self.profilePicture;
}

-(void)setIsOnline:(BOOL *)isOnline {
  self.isOnline = isOnline;
}

-(BOOL)getIsOnline {
  return self.isOnline;
}

@end
