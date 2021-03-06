//
//  ParseService.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Interest.h"
#import "Activity.h"

@interface ParseService : NSObject

+(void)queryForUserWithId:(NSString *)userID completionHandler:(void(^)(User *user))completion;
+(void)queryForInterests:(void(^)(NSArray *interests))completion;
+(void)queryForAllUsers:(void(^)(NSArray *users))completion;
+(void)addInterestToCurrentUser:(Interest *)interest;
+(void)removeInterestFromCurrentUser:(Interest *)interest;
+(void)addMatchForCurrentUser:(User *)newMatch;
+(void)addMismatchForCurrentUser:(User *)newMismatch;
+(void)addUserToActivity:(Activity *)activity;
+(void)removeUserFromActivity:(Activity *)activity;
+(void)checkForMatch:(User *)possibleMatch completionHandler:(void(^)(BOOL match, User *matchedUser))completion;
+(void)sendPushToNewMatch:(User *)user;
+(void)removeUserFromActivity:(Activity *)activity;
+(void)addJoinedActivityToUser:(Activity *)activity;
@end
