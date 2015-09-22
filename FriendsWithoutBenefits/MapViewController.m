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
#import "FSQCategory.h"
#import "FSQLocation.h"
#import "FSQStats.h"
#import "Keys.h"
#import "Constants.h"
#import "FSQCategoryIDs.h"


@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate,
          UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *venues;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation MapViewController

BOOL lsON = FALSE;
BOOL lsAllowed = FALSE;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
  
  

  
  //initial mapView is of downtown Seattle
//  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6097, -122.3331), 5550, 5550) animated:true];
  
   // [self configureRestKit];
    //[self loadVenues];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (nil == self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
      [self.locationManager requestWhenInUseAuthorization];
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self configureRestKit];
        [self loadVenues];
      }
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
  
  // define category object and relationship mapping
  RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[FSQCategory class]];
  [categoryMapping addAttributeMappingsFromDictionary:@{@"id": @"catID", @"icon": @"icon", @"name": @"name"}];
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"category" toKeyPath:@"category" withMapping:categoryMapping]];
  
  // define location object and relationship mapping
  RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[FSQLocation class]];
  [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
  
  // define stats object and relationship mapping
  RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[FSQStats class]];
  [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
  
 
  
}

//Initial code structure sourced from RayW tutorial code
- (void)loadVenues
{
  [self getUserLocation];
  //use the User's current location as the reference point for loading venues
  NSString *latLon;
  NSNumber *latN = [NSNumber numberWithDouble: self.currentLocation.coordinate.latitude];
  latLon = [latN stringValue];
  latLon = [latLon stringByAppendingString:@","];
  
  NSNumber *lngN = [NSNumber numberWithDouble: self.currentLocation.coordinate.longitude];
  latLon = [latLon stringByAppendingString:[lngN stringValue]];
  
  NSString *clientID = kCLIENTID;
  NSString *clientSecret = kCLIENTSECRET;
  NSString *categoryIDs = kFCoffeeShops;
  categoryIDs = [categoryIDs stringByAppendingString:@","];
  categoryIDs = [categoryIDs stringByAppendingString:KAEMuseums];
  
  NSDictionary *queryParams = @{@"ll" : latLon,
                                @"client_id" : clientID,
                                @"client_secret" : clientSecret,
                                @"categoryId" : categoryIDs,
                                @"v" : @"20140118"};
  
  [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                         parameters:queryParams
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              _venues = mappingResult.array;
                                              for (FSQVenue *venue in _venues) {
                                                [self createAnnotation:venue];
                                              }
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              [self presentNoVenuesAlert];
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

- (void)presentNoVenuesAlert
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kNoVenuesTitle message:kNoVenuesMsg preferredStyle:UIAlertControllerStyleAlert];
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
  
  self.currentLocation = self.locationManager.location;
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 5000, 5000) animated:true];
  
  [self.locationManager stopUpdatingLocation];
  
}

-(void)createAnnotation:(FSQVenue *)venue {
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  double lat = [venue.location.lat doubleValue];
  double lng = [venue.location.lng doubleValue];
  
  annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
  annotation.title = venue.name;
  
//  annotation.subtitle = @"Lat: ";
//  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLat];
//  annotation.subtitle = [annotation.subtitle stringByAppendingString:@"  Long:"];
//  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLong];
  
  [self.mapView addAnnotation:annotation];
  
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation* location = [locations lastObject];
  self.currentLocation = location;
  // NSLog(@"lat: %f, long: %f",location.coordinate.latitude, location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch ([CLLocationManager authorizationStatus]) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
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
  
  [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
  
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
  pinView.pinTintColor = [MKPinAnnotationView redPinColor];
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
