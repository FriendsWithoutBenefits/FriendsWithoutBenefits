//
//  ParseService.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ParseService : NSObject

+(void)queryForUserWithId:(NSString *)userID completionHandler:(void(^)(User *user))completion;

@end