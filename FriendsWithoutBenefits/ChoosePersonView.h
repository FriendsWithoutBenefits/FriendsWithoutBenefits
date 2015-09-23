//
//  ChoosePersonView.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "User.h"

@interface ChoosePersonView : MDCSwipeToChooseView

@property (strong, nonatomic) User *currentUser;

- (instancetype)initWithFrame:(CGRect)frame
                      options:(MDCSwipeToChooseViewOptions *)options
                         user:(User *)user;

@end
