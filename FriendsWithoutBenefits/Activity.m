//
//  Activity.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"

@implementation Activity
@dynamic title;
@dynamic date;
@dynamic time;
@dynamic about;
@dynamic location;
//Location, coordinates FSQ stuff?
@dynamic picture;
@dynamic interest;
//Related to what Interests, what kind of data structure is best?
@dynamic attendees;
@dynamic owner;


+ (void)load
{
  [self registerSubclass];
}

+ (void)queryForAllActivities {
  PFQuery *activities = [Activity query];
  
}

+ (NSString *__nonnull)parseClassName {
  return @"Activity";
}
- (NSString *)activityIdentifier
{
  return self.objectId;
}
@end
