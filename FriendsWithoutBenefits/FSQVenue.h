//
//  FSQVenue.h
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class FSQLocation;
@class FSQStats;

@interface FSQVenue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) FSQLocation *location;
@property (nonatomic, strong) FSQStats *stats;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) MKPointAnnotation *annotation;

@end
