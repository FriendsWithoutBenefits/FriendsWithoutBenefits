//
//  ChoosePersonView.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ChoosePersonView.h"
#import "PersonView.h"

@implementation ChoosePersonView

- (instancetype)initWithFrame:(CGRect)frame
                      options:(MDCSwipeToChooseViewOptions *)options
                         user:(User *)user{
  
  self = [super initWithFrame:frame options:options];
  if (self) {
    
    self.currentUser = user;
    
    //Set Up Inner View From Xib
    PersonView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"PersonView" owner:self options:nil] lastObject];
    CGRect insideFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    xibView.frame = insideFrame;
    
    //TODO - Set Labels
    xibView.nameLabel.text = user.firstName;
    
    [self insertSubview:xibView atIndex:0];
  }
  
  return self;
}

@end
