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
#import "Keys.h"
#import "LayerService.h"

@interface ConversationListViewController () <ATLConversationListViewControllerDataSource, ATLConversationListViewControllerDelegate>


@end

@implementation ConversationListViewController

#pragma Lifecycle Methods
-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  // Initializes a LYRClient object
    LayerService *sharedService = [LayerService sharedService];
    LYRClient *layerClient = sharedService.layerClient;
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
  
  if ([conversation.metadata valueForKey:@"title"]) {
    return [conversation.metadata valueForKey:@"title"];
  } else {
    
  }
  
  return @"Conversation Title Error";
}

#pragma mark - ATLConversationListViewControllerDelegate
- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didSelectConversation:(LYRConversation *)conversation {
  ConversationViewController *destinationVC = [[ConversationViewController alloc] initWithLayerClient:self.layerClient];
  destinationVC.conversation = conversation;
  [self.navigationController pushViewController:destinationVC animated:true];
}

@end
