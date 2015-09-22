//
//  ConversationViewController.m
//  FriendsWithoutBenefits
//
//  Created by Jeffrey Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ConversationViewController.h"
#import "ParseService.h"
#import "User.h"

@interface ConversationViewController () <ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate>

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) User *participant;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  self.dataSource = self;
  self.delegate = self;
  self.addressBarController.delegate = self;
  
  // Setup the dateformatter used by the dataSource.
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
  self.dateFormatter.timeStyle = NSDateFormatterShortStyle;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Configuration methods

- (void)configureUI
{
  [[ATLOutgoingMessageCollectionViewCell appearance] setMessageTextColor:[UIColor whiteColor]];
}

#pragma mark - ATLConversationViewControllerDelegate methods

- (void)conversationViewController:(ATLConversationViewController *)viewController didSendMessage:(LYRMessage *)message
{
  NSLog(@"Message sent!");
}

- (void)conversationViewController:(ATLConversationViewController *)viewController didFailSendingMessage:(LYRMessage *)message error:(NSError *)error
{
  NSLog(@"Message failed to sent with error: %@", error);
}

- (void)conversationViewController:(ATLConversationViewController *)viewController didSelectMessage:(LYRMessage *)message
{
  NSLog(@"Message selected");
}

#pragma mark - ATLConversationViewControllerDataSource methods

- (id<ATLParticipant>)conversationViewController:(ATLConversationViewController *)conversationViewController participantForIdentifier:(NSString *)participantIdentifier
{
  //TODO

  return nil;
}

- (NSAttributedString *)conversationViewController:(ATLConversationViewController *)conversationViewController attributedStringForDisplayOfDate:(NSDate *)date
{
  NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName : [UIColor grayColor] };
  return [[NSAttributedString alloc] initWithString:[self.dateFormatter stringFromDate:date] attributes:attributes];
}

- (NSAttributedString *)conversationViewController:(ATLConversationViewController *)conversationViewController attributedStringForDisplayOfRecipientStatus:(NSDictionary *)recipientStatus
{
  if (recipientStatus.count == 0) return nil;
  NSMutableAttributedString *mergedStatuses = [[NSMutableAttributedString alloc] init];
  
  [[recipientStatus allKeys] enumerateObjectsUsingBlock:^(NSString *participant, NSUInteger idx, BOOL *stop) {
    LYRRecipientStatus status = [recipientStatus[participant] unsignedIntegerValue];
    if ([participant isEqualToString:self.layerClient.authenticatedUserID]) {
      return;
    }
    
    NSString *checkmark = @"✔︎";
    UIColor *textColor = [UIColor lightGrayColor];
    if (status == LYRRecipientStatusSent) {
      textColor = [UIColor lightGrayColor];
    } else if (status == LYRRecipientStatusDelivered) {
      textColor = [UIColor orangeColor];
    } else if (status == LYRRecipientStatusRead) {
      textColor = [UIColor greenColor];
    }
    NSAttributedString *statusString = [[NSAttributedString alloc] initWithString:checkmark attributes:@{NSForegroundColorAttributeName: textColor}];
    [mergedStatuses appendAttributedString:statusString];
  }];
  return mergedStatuses;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
