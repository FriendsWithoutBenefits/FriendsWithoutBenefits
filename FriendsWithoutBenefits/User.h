//
//  User.h
//  FriendsWithoutBenefits
//
//  Created by Sau Chung Loh on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

-(void)setFirstName:(NSString *)firstName;
-(void)setLastName:(NSString *)lastName;
-(NSString *)getFullName;

-(void)setAge:(NSNumber *)age;
-(NSNumber *)getAge;

-(void)setAboutMe:(NSString *)aboutMe;

-(void)setProfilePicture:(UIImage *)profilePicture;
-(UIImage *)getProfilePicture;

@end
