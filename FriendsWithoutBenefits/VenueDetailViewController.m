//
//  VenueDetailViewController.m
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/23/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "FSQLocation.h"

@interface VenueDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation VenueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = self.venue.name;
  
  self.addrLabel.text = self.venue.location.address;
  self.cityStateZipLabel.text = self.venue.location.city;
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:@", "];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:self.venue.location.state];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:@" "];
  self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:self.venue.location.postalCode];
  self.countryLabel.text = self.venue.location.country;
  
}




//                                              dispatch_group_t group = dispatch_group_create();
//                                              dispatch_queue_t imageQueue = dispatch_queue_create("JeffJacka.FriendsWithoutBenefits",DISPATCH_QUEUE_CONCURRENT );
//

//                                                NSDictionary *cat = venue.categories[0];
//                                                NSDictionary *icon = cat[@"icon"];
//                                                NSString *prefix = icon[@"prefix"];
//                                                NSString *suffix = icon[@"suffix"];
//                                                prefix = [prefix stringByAppendingString:suffix];
//
//                                                dispatch_group_async(group, imageQueue, ^{
//                                                  NSString *url = prefix;
//                                                  NSURL *imageURL = [NSURL URLWithString:url];
//                                                  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                                                  UIImage *image = [UIImage imageWithData:imageData];
//                                                  venue.image = image;
//                                                });

@end
