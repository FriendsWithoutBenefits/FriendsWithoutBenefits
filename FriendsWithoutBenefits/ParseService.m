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
  
  PFQuery *query = [PFQuery queryWithClassName:@"User"];
  [query whereKey:@"objectId" equalTo:userID];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if(error) {
      NSLog(@"Parse User ID Query Error");
    }
    if (objects) {
      completion(objects.firstObject);
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

@end
