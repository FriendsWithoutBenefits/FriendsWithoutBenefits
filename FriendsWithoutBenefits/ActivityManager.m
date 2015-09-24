//
//  ActivityManager.m
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ActivityManager.h"

@implementation ActivityManager

@dynamic userOwnedActivities;
@dynamic userSelectedActivities;
@dynamic currentUser;

//+ (void)load
//{
//  //Query for all activities
// // [self registerSubclass];
//}

+ (NSString *__nonnull)parseClassName {
  return @"ActivityManager";
}
+ (void)AddSelectedActivity:(Activity *)selectedActivity
{
  //You will want to alloc init array
  //Append the selectedActivity to the userselectedActivities
  
  
}

+ (void)AddCreatedActivity:(Activity *)createdActivity
{
  //You will want to alloc init array
  //Append the selectedActivity to the userownedActivities
  
}
//dictionary, owners to event?
//Owners with multiple events?
//Array of dicts?
//Query for all events?
@end
