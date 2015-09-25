//
//  MatchViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeff Jacka on 9/22/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

//Features MDCSwipeToChoose Code
//https://github.com/modocache/MDCSwipeToChoose

#import "MatchViewController.h"
#import "NewMatchViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "User.h"
#import "ParseService.h"

@interface MatchViewController ()

@property (strong, nonatomic) NSMutableArray *people;

@end

@implementation MatchViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
  
  //Configure Nav Bar Look
  [self.navigationController.navigationBar
   setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  
  //TODO: Change Query with better logic
  //TODO: GCD/Operation Queue to make more responsive
  [ParseService queryForAllUsers:^(NSArray *users) {
    self.people = [[NSMutableArray alloc] init];
    self.people = [NSMutableArray arrayWithArray:users];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontUserView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backUserView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backUserView belowSubview:self.frontUserView];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Frame Construction
- (CGRect)frontCardViewFrame {
  CGFloat horizontalPadding = 20.f;
  CGFloat topPadding = 80.f;
  CGFloat bottomPadding = 200.f;
  return CGRectMake(horizontalPadding,
                    topPadding,
                    CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                    CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
  CGRect frontFrame = [self frontCardViewFrame];
  return CGRectMake(frontFrame.origin.x,
                    frontFrame.origin.y + 10.f,
                    CGRectGetWidth(frontFrame),
                    CGRectGetHeight(frontFrame));
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
  // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
  // and "LIKED" on swipes to the right.
  if (direction == MDCSwipeDirectionLeft) {
    //User was noped
    NSLog(@"You noped %@.", self.currentUser.firstName);
    
    //Add to disliked Users
    [ParseService addMismatchForCurrentUser:self.currentUser];
  } else {
    //User was liked
    NSLog(@"You liked %@.", self.currentUser.firstName);
    //Add to liked users
    [ParseService addMatchForCurrentUser:self.currentUser];
    
    [ParseService checkForMatch:self.currentUser completionHandler:^(BOOL match, User *matchedUser) {
      if (match) {
        NSLog(@"Users are a match! Matched with: %@", matchedUser.firstName);
        //Show Match VC
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *newMatchNC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NewMatchNC"];
        NewMatchViewController *newMatchVC = (NewMatchViewController *)newMatchNC.topViewController;
        newMatchVC.matchedUser = matchedUser;
        [self presentViewController:newMatchNC animated:true completion:nil];
        
        //Send Notification to second user
        [ParseService sendPushToNewMatch:matchedUser];
      }
    }];
  }
  
  // MDCSwipeToChooseView removes the view from the view hierarchy
  // after it is swiped (this behavior can be customized via the
  // MDCSwipeOptions class). Since the front card view is gone, we
  // move the back card to the front, and create a new back card.
  self.frontCardView = self.backUserView;
  if ((self.backUserView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
    // Fade the back card into view.
    self.backUserView.alpha = 0.f;
    [self.view insertSubview:self.backUserView belowSubview:self.frontUserView];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       self.backUserView.alpha = 1.f;
                     } completion:nil];
  }
}

#pragma mark - Internal Methods
- (void) setFrontCardView:(ChoosePersonView *)frontCardView {
  _frontUserView = frontCardView;
  self.currentUser = frontCardView.currentUser;
  
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
  if ([self.people count] == 0) {
    return nil;
  }
  
  // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
  // Each take an "options" argument. Here, we specify the view controller as
  // a delegate, and provide a custom callback that moves the back card view
  // based on how far the user has panned the front card view.
  MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
  options.delegate = self;
  options.threshold = 160.f;
  options.onPan = ^(MDCPanState *state){
    CGRect frame = [self backCardViewFrame];
    self.backUserView.frame = CGRectMake(frame.origin.x,
                                         frame.origin.y - (state.thresholdRatio * 10.f),
                                         CGRectGetWidth(frame),
                                         CGRectGetHeight(frame));
  };
  
  // Create a personView with the top person in the people array, then pop
  // that person off the stack.
  ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame options:options user:self.people[0]];
  [self.people removeObjectAtIndex:0];
  
  return personView;
}

#pragma mark - IBActions 
- (IBAction)meetButtonPressed:(id)sender {
  [self.frontUserView mdc_swipe:MDCSwipeDirectionRight];
}

- (IBAction)hideButtonPressed:(id)sender {
  [self.frontUserView mdc_swipe:MDCSwipeDirectionLeft];
}


@end
