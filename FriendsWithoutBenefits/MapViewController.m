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
#import "VenueDetailViewController.h"
#import <UIKit/UIKit.h>


@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate,
          UIGestureRecognizerDelegate, UIAlertViewDelegate>

- (IBAction)venueSegControl:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@property (nonatomic, strong) NSArray *venues;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) FSQVenue *selectedVenue;

@end

@implementation MapViewController

NSString *selLatitude;
NSString *selLongitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Venues";
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    [self setupLongPress];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //StackOverflow answer to question about changing text color on UISegmented contrls
  NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:12], NSFontAttributeName,
                              [UIColor blackColor], NSForegroundColorAttributeName,
                              nil];
  [self.segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
  NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
  [self.segControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
  
  //construct initial categoryID array
  NSMutableArray *catStr = [[NSMutableArray alloc] init];
  [catStr addObject:kFCoffeeShops];
  
  NSString *categoryIDs = [self generateCategoryIdString:catStr];
  
  
  if (nil == self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
      [self configureRestKit];
      [self loadVenues:categoryIDs];
    } else {
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
          [self.locationManager requestWhenInUseAuthorization];
          if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
              [self configureRestKit];
            [self loadVenues:categoryIDs];
          }
      } else {
        [self presentLocationServicesAlert];
        //initial mapView is of downtown Seattle
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6097, -122.3331), 5550, 5550) animated:true];
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
  [venueMapping addAttributeMappingsFromArray:@[@"name", @"categories", @"photo"]];
  
  
  // define location object and relationship mapping
  RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[FSQLocation class]];
  [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
  
  // define stats object and relationship mapping
  RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[FSQStats class]];
  [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
  
  // register mappings with the provider using a response descriptor
  RKResponseDescriptor *responseDescriptor =
  [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                               method:RKRequestMethodGET
                                          pathPattern:@"/v2/venues/search"
                                              keyPath:@"response.venues"
                                          statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  [objectManager addResponseDescriptor:responseDescriptor];
  
}

//Initial code structure sourced from RayW tutorial code
- (void)loadVenues:(NSString *)categoryIDs
{
  [self.mapView removeAnnotations:[self.mapView annotations]];
  [self getUserLocation];
  //use the User's current location as the reference point for loading venues
  NSString *latLon;
  NSNumber *latN = [NSNumber numberWithDouble: self.currentLocation.coordinate.latitude];
  latLon = [latN stringValue];
  latLon = [latLon stringByAppendingString:@","];
  
  NSNumber *lngN = [NSNumber numberWithDouble: self.currentLocation.coordinate.longitude];
  latLon = [latLon stringByAppendingString:[lngN stringValue]];
  
  //credentials for FourSquare
  NSString *clientID = kCLIENTID;
  NSString *clientSecret = kCLIENTSECRET;
  
  NSDictionary *queryParams = @{@"ll" : latLon,
                                @"client_id" : clientID,
                                @"client_secret" : clientSecret,
                                @"categoryId" : categoryIDs,
                                @"radius" : @100000,
                                // @"query" : querySearch,
                                @"limit" : @50,
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

-(NSString *)generateCategoryIdString:(NSArray *)catIDArray {
  
  NSString *categoryIDs = @"";
  for (NSString *catID in catIDArray) {
    categoryIDs = [categoryIDs stringByAppendingString:catID];
    if (catID != catIDArray.lastObject) {
      categoryIDs = [categoryIDs stringByAppendingString:@","];
    }
  }
  return categoryIDs;
}

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
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 5000, 5000) animated:true];
  
  [self.locationManager stopUpdatingLocation];
  
}

-(void)createAnnotation:(FSQVenue *)venue {
  
  static double multiplier = 0.000621371;
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  double lat = [venue.location.lat doubleValue];
  double lng = [venue.location.lng doubleValue];
  
  annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
  annotation.title = venue.name;
  
  //setup subtitle with the Distance in miles
  annotation.subtitle = @"Distance: ";
  //convert meters to miles
  NSNumber *distance = venue.location.distance;
  distance = @([distance floatValue] * multiplier);
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  [formatter setMaximumFractionDigits:2];
  NSString *distanceFormatted = [formatter stringFromNumber:distance];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:distanceFormatted];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:@"  miles"];
  venue.annotation = annotation;
  
  [self.mapView addAnnotation:annotation];
  
}

-(void)setupLongPress{
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(executeLongPress:)];
  longPress.minimumPressDuration = .5; //seconds
  longPress.delegate = self;
  [self.mapView addGestureRecognizer:longPress];
}

-(void)executeLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
    return;
  }
  CGPoint p = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
  
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
  annotation.title = @"Long Press Location";
  
  NSString *coordLat = [NSString stringWithFormat:@"%f", coordinate.latitude];
  NSString *coordLong = [NSString stringWithFormat:@"%f", coordinate.longitude];
  selLatitude = coordLat;
  selLongitude = coordLong;
  
  annotation.subtitle = @"Lat: ";
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLat];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:@"  Long:"];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLong];
  
  [self.mapView addAnnotation:annotation];
  
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation* location = [locations lastObject];
  self.currentLocation = location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch ([CLLocationManager authorizationStatus]) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      break;
    case kCLAuthorizationStatusAuthorizedAlways:
      [self.locationManager startUpdatingLocation];
      break;
    case kCLAuthorizationStatusRestricted:
      [self presentLocationServicesAlert];
      break;
    case kCLAuthorizationStatusDenied:
      [self presentLocationServicesAlert];
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
  
  for (FSQVenue *venue in self.venues){
    if (venue.annotation == view.annotation) {
      self.selectedVenue = venue;
//      VenueDetailViewController *venueDetailVC = [[VenueDetailViewController alloc] init];
//      [self.navigationController pushViewController:venueDetailVC animated:YES];
      [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
    }
  }
  
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([[segue identifier] isEqualToString:@"ShowVenueDetail"]) {
    VenueDetailViewController *venueDetailVC = [segue destinationViewController];
    venueDetailVC.venue = self.selectedVenue;
  }
  
}

- (IBAction)venueSegControl:(UISegmentedControl *)sender {
  
  NSMutableArray *catStr = [[NSMutableArray alloc] init];
  
  switch (sender.selectedSegmentIndex)
  {
    case 0:
      [catStr addObject:kOutdoorsAndRecreation];
      break;
    case 1:
      [catStr addObject:kNightlifeSpot];
      break;
    case 2:
      [catStr addObject:kFood];
      break;
    case 3:
      [catStr addObject:kEvents];
      break;
    default:
      [catStr addObject:kFCoffeeShops];
      break;
  }
  
  NSString *categoryIDs = [self generateCategoryIdString:catStr];
  [self loadVenues:categoryIDs];
  
}

@end
