//
//  FSQVenue.h
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSQCategory;
@class FSQLocation;
@class FSQStats;

@interface FSQVenue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FSQCategory *category;
@property (nonatomic, strong) FSQLocation *location;
@property (nonatomic, strong) FSQStats *stats;

@end
