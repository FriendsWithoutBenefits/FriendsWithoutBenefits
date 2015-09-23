//
//  Interest.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>

@interface Interest : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *name;

+ (NSString *)parseClassName;

@end
