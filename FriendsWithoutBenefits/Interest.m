//
//  Interest.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "Interest.h"

@implementation Interest

@dynamic name;

+ (void)load {
  [self registerSubclass];
}

+ (NSString *)parseClassName {
  return @"Interest";
}

@end
