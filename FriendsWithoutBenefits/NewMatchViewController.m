//
//  NewMatchViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "NewMatchViewController.h"
#import <LayerKit/LayerKit.h>
#import "LayerService.h"
#import "ConversationViewController.h"


@interface NewMatchViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@end

@implementation NewMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.closeButton.title = @"Close";
  self.closeButton.enabled = TRUE;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)startNewConversationAction:(id)sender {
  LYRConversation *newConversation = [LayerService.sharedService createNewMatchConversation:self.matchedUser];
  
  LYRClient *layerClient = [LayerService.sharedService layerClient];
  
      ConversationViewController *newConvoVC = [ConversationViewController conversationViewControllerWithLayerClient:layerClient];
  newConvoVC.conversation = newConversation;
  newConvoVC.displaysAddressBar = YES;
  [self.navigationController pushViewController:newConvoVC animated:YES];
}

- (IBAction)dismissNewMatch:(id)sender {
  [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end