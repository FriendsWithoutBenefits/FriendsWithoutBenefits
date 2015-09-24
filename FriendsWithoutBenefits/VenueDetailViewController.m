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
#import <RestKit/RestKit.h>
#import "FSQVenuePhoto.h"
#import "Keys.h"

@interface VenueDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSString *pathPattern;

@end

@implementation VenueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = self.venue.name;
  
//  self.pathPattern = @"v2/venues/";
//  self.pathPattern = [self.pathPattern stringByAppendingString:self.venue.id];
//  self.pathPattern = [self.pathPattern stringByAppendingString:@"/photos"];
  
  if (self.venue.image == nil) {
//    [self configureRestKit];
//    [self loadVenues];
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
  if (self.venue.location.postalCode != nil) {
     self.cityStateZipLabel.text = [self.cityStateZipLabel.text stringByAppendingString:self.venue.location.postalCode];
  }
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

//Initial code structure sourced from RayW tutorial code
- (void)configureRestKit
{
  // initialize AFNetworking HTTPClient
  NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
  
  // initialize RestKit
  RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
  
  // setup object mappings
  RKObjectMapping *venuePhotoMapping = [RKObjectMapping mappingForClass:[FSQVenuePhoto class]];
  [venuePhotoMapping addAttributeMappingsFromArray:@[@"items"]];

  // register mappings with the provider using a response descriptor
  RKResponseDescriptor *responsePhotos =
  [RKResponseDescriptor responseDescriptorWithMapping:venuePhotoMapping
                                               method:RKRequestMethodGET
                                          pathPattern:self.pathPattern
                                              keyPath:@"response.photos"
                                          statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  [objectManager addResponseDescriptor:responsePhotos];
  
  NSLog(@"Arg");
  
}

//Initial code structure sourced from RayW tutorial code
- (void)loadVenues
{
  
  //credentials for FourSquare
  NSString *clientID = kCLIENTID;
  NSString *clientSecret = kCLIENTSECRET;
  
  NSDictionary *queryParams = @{
                               @"client_id" : clientID,
                                @"client_secret" : clientSecret,
                               @"v" : @"20140118"
                                };
  
  [[RKObjectManager sharedManager] getObjectsAtPath:self.pathPattern
                                         parameters:queryParams
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              _photos = mappingResult.array;
                                              for (FSQVenuePhoto *venuePhoto in _photos) {
                                                NSLog(@"I got a photo");
                                              }
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              NSLog(@"%@", error.description);
                                              NSLog(@"I did not get a photo");
                                              //[self presentNoVenuesAlert];
                                            }];
}












@end
