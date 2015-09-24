//
//  VenueDetailViewController.m
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "FSQLocation.h"
#import <UIKit/UIKit.h>

@interface VenueDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

@end

@implementation VenueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = self.venue.name;
  
  if (self.venue.image == nil) {
    [self determineStockPhoto:self.venue.categories[0]];
    //[self retrieveCategoryIcon:self.venue.categories[0]];
  }
  self.imageView.image = self.venue.image;
  self.venueLabel.text = self.venue.name;
  
  self.addrLabel.text = self.venue.location.address;
  self.cityStateZipLabel.text = self.venue.location.city;
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:@", "];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:self.venue.location.state];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:@" "];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:self.venue.location.postalCode];
  self.countryLabel.text = self.venue.location.country;
  
}

-(void)retrieveCategoryIcon:(NSDictionary *)catIcon {
  
  NSDictionary *icon = catIcon[@"icon"];
  NSString *prefix = icon[@"prefix"];
  NSString *suffix = icon[@"suffix"];
  prefix = [prefix stringByAppendingString:suffix];
  
  NSString *url = prefix;
  NSURL *imageURL = [NSURL URLWithString:url];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  UIImage *image = [UIImage imageWithData:imageData];
  self.venue.image = image;
}

-(void)determineStockPhoto:(NSDictionary *)venueType {
  
 // NSString *name = venueType[@"name"];
  UIImage *image = [UIImage imageNamed: @"AE_IMAGE.jpg"];
  self.venue.image = image;
  
}
@end
