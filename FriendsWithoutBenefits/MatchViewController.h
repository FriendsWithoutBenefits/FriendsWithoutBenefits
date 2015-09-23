//
//  MatchViewController.h
//  FriendsWithoutBenefits
//
//  Created by Jeff Jacka on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePersonView.h"
#import "User.h"

@interface MatchViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) ChoosePersonView *frontUserView;
@property (strong, nonatomic) ChoosePersonView *backUserView;

@end
