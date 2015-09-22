//
//  User.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>

@interface User()

@end

@implementation User

@dynamic name;
@dynamic firstName;
@dynamic lastName;
@dynamic age;
@dynamic aboutMe;
@dynamic profilePicture;
@dynamic interests;
@dynamic peopleMatched;
@dynamic peopleNotMatched;
@dynamic isOnline;
@dynamic user;

+ (NSString * __nonnull)parseClassName {
  return @"User";
}


@end
