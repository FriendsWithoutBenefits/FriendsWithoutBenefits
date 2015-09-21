//
//  ParseService.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ParseService.h"
#import <Parse/Parse.h>

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

@end
