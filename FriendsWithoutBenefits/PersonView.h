//
//  PersonView.h
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PersonView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
