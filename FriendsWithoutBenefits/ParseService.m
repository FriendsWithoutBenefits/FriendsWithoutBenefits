//
//  ParseService.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ParseService.h"
#import <Parse/Parse.h>
#import "Interest.h"
#import "User.h"

@implementation ParseService

+(void)queryForUserWithId:(NSString *)userID completionHandler:(void(^)(User *user))completion {
  
  NSLog(@"About to query for userid : %@", userID);
  PFQuery *query = [User query];
  
  [query getObjectInBackgroundWithId:userID block:^(PFObject * _Nullable object, NSError * _Nullable error) {
    if (!error) {
      completion((User *)object);
    }
  }];
}

+(void)queryForInterests:(void(^)(NSArray *interests))completion {
 
  PFQuery *query = [PFQuery queryWithClassName:@"Interest"];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if(!error) {
      completion(objects);
    }
  }];
}

+(void)queryForAllUsers:(void(^)(NSArray *users))completion {
  
  PFQuery *query = [PFUser query];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if(!error) {
      completion(objects);
    }
  }];
}

+(void)addInterestToCurrentUser:(Interest *)interest {
  User *currentUser = [User currentUser];
  
  PFRelation *relation = [interest relationForKey:@"interestedUsers"];
  [relation addObject:currentUser];
  
  [interest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"Interest relation saved successfulled");
      
      PFRelation *userRelation = [currentUser relationForKey:@"interests"];
      [userRelation addObject:interest];
      [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
          NSLog(@"User-interest relation saved successfully");
        }
      }];
    }
  }];
}

+(void)removeInterestFromCurrentUser:(Interest *)interest {
  User *currentUser = [User currentUser];
  
  PFRelation *userInterestsRelation = currentUser.interests;
  PFRelation *interestsRelation = interest.interestedUsers;
  
  [interestsRelation removeObject:currentUser];
  
  [interest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    if(!error) {
      NSLog(@"Interest relation removed successfully");
      [userInterestsRelation removeObject:interest];
      [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"User-interest relation removed successfully");
      }];
    }
  }];
}

+(void)addMatchForCurrentUser:(User *)newMatch {
  User *currentUser = [User currentUser];
  
  PFRelation *newRelation = [currentUser relationForKey:@"peopleMatched"];
  
  [newRelation addObject:newMatch];
  
  [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"User match saved");
    }
  }];
}

+(void)addMismatchForCurrentUser:(User *)newMismatch {
  User *currentUser = [User currentUser];
  
  PFRelation *newRelation = [currentUser relationForKey:@"peopleNotMatched"];
  
  [newRelation addObject:newMismatch];
  
  [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"User mismatch saved");
    }
  }];
}

+(void)checkForMatch:(User *)possibleMatch completionHandler:(void(^)(BOOL match, User *matchedUser))completion {
  User *currentUser = [User currentUser];
  
  //Second to background Queue
  dispatch_queue_t backgroundQueue = dispatch_queue_create("BackgroundQueue", NULL);
  dispatch_async(backgroundQueue, ^{
    //Retrieve both users matches
    NSArray *currentUsersMatches = [self retrieveInterestedUsers:currentUser];
    NSArray *possibleMatchUsers = [self retrieveInterestedUsers:possibleMatch];
    
    //If both users are matched return true
    if ([currentUsersMatches containsObject:possibleMatch] && [possibleMatchUsers containsObject:currentUser]) {
      completion(true, possibleMatch);
    } else {
      completion(false, possibleMatch);
    }
  });
}

+(NSArray *)retrieveInterestedUsers:(User *)user {
  PFRelation *userRelation = user.peopleMatched;
  PFQuery *query = [userRelation query];
  
  NSArray *matchedUsers = [query findObjects];
  
  return matchedUsers;
}

+(void)addUserToActivity:(Activity *)activity {
  User *currentUser = [User currentUser];
  [activity addObject:currentUser forKey: @"attendees"];
  [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    [currentUser addObject:activity forKey:@"joinedActivities"];
  }];
}

+(void)sendPushToNewMatch:(User *)user {
  // Create our Installation query
  PFQuery *pushQuery = [PFInstallation query];
  [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
  [pushQuery whereKey:@"user" equalTo:user];
  
  NSDictionary *data = @{@"alert":@"New Matched User!",
                         @"user":[User currentUser].objectId};
  
  // Send push notification to query
  PFPush *newPush = [[PFPush alloc] init];
  [newPush setQuery:pushQuery];
  [newPush setData:data];
  
  [newPush sendPushInBackground];
  
}

+(void)removeUserFromActivity:(Activity *)activity {
  [activity removeObject:[User currentUser] forKey:@"attendees"];
  [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    [[User currentUser] removeObject:activity forKey:@"joinedActivities"];
  }];
}


@end
