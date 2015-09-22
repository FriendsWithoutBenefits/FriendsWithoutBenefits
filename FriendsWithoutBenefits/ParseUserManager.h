//
//  ParseUserManager.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFUser;
@class LYRConversation;

@interface ParseUserManager : NSObject

+ (instancetype)sharedManager;
- (void)queryForUserWithName:(NSString *)searchText completion:(void (^)(NSArray *participants, NSError *error))completion;
- (void)queryForAllUsersWithCompletion:(void (^)(NSArray *users, NSError *error))completion;
- (void)queryAndCacheUsersWithIDs:(NSArray *)userIDs completion:(void (^)(NSArray *participants, NSError *error))completion;
- (PFUser *)cachedUserForUserID:(NSString *)userID;
- (void)cacheUserIfNeeded:(PFUser *)user;
- (NSArray *)unCachedUserIDsFromParticipants:(NSArray *)participants;
- (NSArray *)resolvedNamesFromParticipants:(NSArray *)participants;

@end
