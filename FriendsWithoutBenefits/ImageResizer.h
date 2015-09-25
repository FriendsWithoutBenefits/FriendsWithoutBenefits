//
//  ImageResizer.h
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageResizer : NSObject

+ (UIImage*)resizeImageWithImage:(UIImage*)image toSize:(CGSize)newSize;

@end
