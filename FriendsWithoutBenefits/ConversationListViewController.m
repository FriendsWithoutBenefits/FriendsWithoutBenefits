//
//  ConversationListViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "AppDelegate.h"

@interface ConversationListViewController () <ATLConversationListViewControllerDataSource, ATLConversationListViewControllerDelegate>


@end

@implementation ConversationListViewController

#pragma Lifecycle Methods
-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  // Initializes a LYRClient object
  static NSString *const LayerAppIDString = @"layer:///apps/staging/c18f2932-5e63-11e5-a5eb-130000000104";
  NSURL *appID = [NSURL URLWithString:LayerAppIDString];
  LYRClient *layerClient = [LYRClient clientWithAppID:appID];
  return [super initWithLayerClient:layerClient];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    self.dataSource = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ATLConversationListViewControllerDatasource
- (NSString *)conversationListViewController:(ATLConversationListViewController *)conversationListViewController titleForConversation:(LYRConversation *)conversation {
  return @"This is my conversation title";
}

#pragma mark - ATLConversationListViewControllerDelegate
- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didSelectConversation:(LYRConversation *)conversation {
  ConversationViewController *destinationVC = [[ConversationViewController alloc] initWithLayerClient:self.layerClient];
  destinationVC.conversation = conversation;
  [self.navigationController pushViewController:destinationVC animated:true];
}



@end
