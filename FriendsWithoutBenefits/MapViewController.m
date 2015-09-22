//
//  MapViewController.m
//  FriendsWithoutBenefits
//
//  Created by Joey Nessif on 9/21/15.
//  Copyright © 2015 Jeffrey Jacka. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FSQVenue.h"
#import "FSQLocation.h"
#import "FSQStats.h"
#import "Keys.h"
#import "Constants.h"
#import "FSQCategoryIDs.h"


@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate,
          UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *venues;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

BOOL lsON = FALSE;
BOOL lsAllowed = FALSE;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
  
  //initial mapView is of downtown Seattle
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6097, -122.3331), 5550, 5550) animated:true];
  
    [self configureRestKit];
    [self loadVenues];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (nil == self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
      [self.locationManager requestWhenInUseAuthorization];
    }
  }

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
  RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[FSQVenue class]];
  [venueMapping addAttributeMappingsFromArray:@[@"name"]];
  
  // register mappings with the provider using a response descriptor
  RKResponseDescriptor *responseDescriptor =
  [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                               method:RKRequestMethodGET
                                          pathPattern:@"/v2/venues/search"
                                              keyPath:@"response.venues"
                                          statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  [objectManager addResponseDescriptor:responseDescriptor];
  
  // define location object mapping
  RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[FSQLocation class]];
  [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
  
  // define relationship mapping
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
  
  RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[FSQStats class]];
  [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
  
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
}

//Initial code structure sourced from RayW tutorial code
- (void)loadVenues
{
  NSString *latLon = @"47.61,-122.33";
  NSString *clientID = kCLIENTID;
  NSString *clientSecret = kCLIENTSECRET;
  
  NSDictionary *queryParams = @{@"ll" : latLon,
                                @"client_id" : clientID,
                                @"client_secret" : clientSecret,
                                @"categoryId" : kCoffeeShops,
                                @"v" : @"20140118"};
  
  [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                         parameters:queryParams
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              _venues = mappingResult.array;
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                            }];
}

#pragma mark - User-defined functions

- (void)presentLocationServicesAlert
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocationServicesTitle message:kLocationServicesMsg preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [alertController dismissViewControllerAnimated:true completion:nil];
  }];
  [alertController addAction:action];
  
  [self presentViewController:alertController animated:true completion:nil];
}

- (void)getUserLocation
{
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.distanceFilter = 500;
  [self.locationManager startUpdatingLocation];
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1000, 1000) animated:true];
  
  [self.locationManager stopUpdatingLocation];
  
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch ([CLLocationManager authorizationStatus]) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      [self getUserLocation];
       self.mapView.showsUserLocation = true;
      lsAllowed = TRUE;
      break;
    case kCLAuthorizationStatusAuthorizedAlways:
      [self.locationManager startUpdatingLocation];
      lsAllowed = TRUE;
      break;
    case kCLAuthorizationStatusRestricted:
      [self presentLocationServicesAlert];
      lsAllowed = FALSE;
      break;
    case kCLAuthorizationStatusDenied:
      [self presentLocationServicesAlert];
      lsAllowed = FALSE;
      break;
    case kCLAuthorizationStatusNotDetermined:
      [self.locationManager requestWhenInUseAuthorization];
      break;
    default:
      break;
  }

}

#pragma mark - MapView Delegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
  [self performSegueWithIdentifier:@"ShowAddReminder" sender:self];
  
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  NSString *reuseID = @"AnnotationView";
  
  MKPinAnnotationView *pinView =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
  
  if (!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
  } else {
    pinView.annotation = annotation;
  }
  
  pinView.animatesDrop = true;
  pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
  pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  pinView.canShowCallout = YES;
  
  return pinView;
  
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
