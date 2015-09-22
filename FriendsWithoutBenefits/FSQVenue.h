//
//  FSQVenue.h
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSQLocation;
@class FSQStats;

@interface FSQVenue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FSQLocation *location;
@property (strong, nonatomic) FSQStats *stats;

@end
