//
//  Activity.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "Interest.h"

@interface Activity : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) PFGeoPoint *location;
//Location, coordinates FSQ stuff?
@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) Interest *interest;
//Interests, what kind of data structure is best?
@property (strong, nonatomic, readonly) PFRelation *attendees;
@property (strong, nonatomic) User *owner;
-(void)usersInActivity:(void(^)(NSArray *users))completion;

@end
