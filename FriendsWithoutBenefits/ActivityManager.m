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

+ (void)load
{
  [self registerSubclass];
}
//dictionary, owners to event?
//Owners with multiple events?
//Array of dicts?
//Query for all events?
@end
