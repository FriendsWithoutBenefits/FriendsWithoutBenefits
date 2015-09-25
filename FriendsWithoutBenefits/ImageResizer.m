//
//  ImageResizer.m
//  FriendsWithoutBenefits
//
//  Created by MICK SOUMPHONPHAKDY on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "ImageResizer.h"

@implementation ImageResizer

// source: http://transoceanic.blogspot.com/2011/09/objective-c-resize-image.html
+ (UIImage*)resizeImageWithImage:(UIImage*)image toSize:(CGSize)newSize
{
  // Create a graphics image context
  UIGraphicsBeginImageContext(newSize);
  
  // draw in new context, with the new size
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  
  // Get the new image from the context
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // End the context
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end
