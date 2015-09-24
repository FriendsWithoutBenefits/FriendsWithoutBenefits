//
//  LayerService.h
//  FriendsWithoutBenefits
//
//  Created by Jeff Jacka on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "User.h"

@interface LayerService : NSObject

@property (strong, nonatomic) LYRClient *layerClient;

+(id)sharedService;
-(void)loginLayer;
-(LYRConversation *)createNewMatchConversation:(User *)newMatch;

@end
