//
//  User.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "User.h"
#import <LayerKit/LayerKit.h>


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
@dynamic avatarImage;
@dynamic avatarImageURL;
@dynamic joinedActivities;
@dynamic profileImageFile;

+(void)load {
    [self registerSubclass];
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)participantIdentifier
{
    return self.objectId;
}

- (NSString *)avatarInitials
{
    return [[NSString stringWithFormat:@"%@%@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]] uppercaseString];
}

-(void)userInterests:(void(^)(NSArray *interests))completion {
  PFRelation *interests = self.interests;
  
  PFQuery *query = [interests query];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if (!error) {
      completion(objects);
    }
  }];
}

//TODO - AvatarImage & AvatarImageURL


@end
