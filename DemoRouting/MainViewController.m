//
//  MainViewController.m
//  DemoRouting
//
//  Created by Zdc006-Hoang Dung on 11/26/15.
//  Copyright © 2015 Test. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    MKRoute *routeDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.startPointTf.returnKeyType = UIReturnKeyDone;
    self.startPointTf.tag = 100;
    self.startPointTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.endPointTf.returnKeyType = UIReturnKeyDone;
    self.endPointTf.tag = 101;
    self.endPointTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // start location
    [self startLocation];
    
    //    MKUserLocation *userLocation = self.mapView.userLocation;
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
    //                                                                   20000, 20000);
    self.mapView.showsUserLocation = YES;
    // [self.mapView setRegion:region animated:NO];
    [self.mapView setZoomEnabled: YES];
    [self.mapView setScrollEnabled: YES];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = 0.5;  //user must press for 0.5 second
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction methods

- (IBAction)startRoute:(UIButton *)sender {
    if (self.startPoint && self.endPoint) {
        [self.mapView removeOverlays:self.mapView.overlays];
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
        
        CLLocationCoordinate2D startcoordinate = CLLocationCoordinate2DMake(self.startPoint.coordinate.latitude, self.startPoint.coordinate.longitude);
        MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startcoordinate addressDictionary:nil];
        MKMapItem *startMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
        [directionsRequest setSource:startMapItem];
        
        CLLocationCoordinate2D endcoordinate = CLLocationCoordinate2DMake(self.endPoint.coordinate.latitude, self.endPoint.coordinate.longitude);
        MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endcoordinate addressDictionary:nil];
        MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
        [directionsRequest setDestination:endMapItem];
        directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
        directionsRequest.requestsAlternateRoutes = YES;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
                [self showAlertViewWithTitle:@"Error" message:@"Route failed"];
            } else {
                if (response.routes.count > 0) {
                    routeDetails = response.routes[0];
                    [self.mapView addOverlay:routeDetails.polyline];
                }
            }
        }];
    } else {
        [self showAlertViewWithTitle:@"Error" message:@"Please choose start and end point!"];
    }
}

# pragma mark - Class methods

- (void)startLocation {
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    else
    {
        nil;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else
    {
        nil;
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (NSString *)getFullAddresFromPlacemark:(CLPlacemark *)placemark {
    NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
    NSString *addressString = [lines componentsJoinedByString:@", "];
    return addressString;
}

- (void)getAddressFromLocation:(CLLocation *)location withTag:(NSInteger)tag {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       
                       if (error) {
                           NSLog(@"Geocode failed with error: %@", error);
                           [self showAlertViewWithTitle:@"Error" message:@"Get address failed"];
                           return;
                       }
                       
                       NSLog(@"placemarks=%@", [placemarks objectAtIndex:0]);
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       NSLog(@"placemark.ISOcountryCode =%@", placemark.ISOcountryCode);
                       NSLog(@"placemark.country =%@", placemark.country);
                       NSLog(@"placemark.postalCode =%@", placemark.postalCode);
                       NSLog(@"placemark.administrativeArea =%@", placemark.administrativeArea);
                       NSLog(@"placemark.locality =%@", placemark.locality);
                       NSLog(@"placemark.subLocality =%@", placemark.subLocality);
                       NSLog(@"placemark.subThoroughfare =%@", placemark.subThoroughfare);
                       
                       if (tag == 100) {
                           self.startPointTf.text = [self getFullAddresFromPlacemark:placemark];
                           self.startPoint = placemark.location;
                       } else {
                           self.endPointTf.text = [self getFullAddresFromPlacemark:placemark];
                           self.endPoint = placemark.location;
                       }
                   }];
}

- (void)findLocationWithTag:(NSInteger)tag {
    //check to see if geocoder initialized, if not initialize it
    if (self.geocoder == nil)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    NSString *address = @"";
    if (tag == 100) {
        address = self.startPointTf.text;
    } else if (tag == 101) {
        address = self.endPointTf.text;
    }
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            
            // Add an annotation
            MyAnnotation *point = [[MyAnnotation alloc] init];
            point.coordinate = coordinate;
            
            if (tag == 100) {
                point.title = @"Start Point";
                self.startPointTf.text = [self getFullAddresFromPlacemark:placemark];
                self.startPoint = placemark.location;
            } else if (tag == 101) {
                point.title = @"End Point";
                self.endPointTf.text = [self getFullAddresFromPlacemark:placemark];
                self.endPoint = placemark.location;
            }
            
            self.mapView.centerCoordinate = coordinate;
            [self addAnnotation:point withTag:tag];
        }
        else if (error.domain == kCLErrorDomain)
        {
            switch (error.code)
            {
                case kCLErrorDenied:
                    break;
                case kCLErrorNetwork:
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    break;
                default:
                    break;
            }
            [self showAlertViewWithTitle:@"Error" message:@"Find location failed"];
        }
        else
        {
            [self showAlertViewWithTitle:@"Error" message:@"Find location failed"];
        }
    }];
}

- (void)addAnnotation:(MyAnnotation *)annotation withTag:(NSInteger)tag {
    NSMutableArray *annotationsList = [self.mapView.annotations mutableCopy];
    for (MyAnnotation *pa in annotationsList) {
        if ( (tag == 100 && [pa.title isEqualToString:@"Start Point"]) || (tag == 101 && [pa.title isEqualToString:@"End Point"]))
            [self.mapView removeAnnotation:pa];
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addAnnotation:annotation];
}

# pragma mark - UILongPressGestureRecognizer method

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self getAddressFromLocation:location withTag:101];
    
    MyAnnotation *pa = [[MyAnnotation alloc] init];
    pa.coordinate = touchMapCoordinate;
    pa.title = @"End Point";
    [self addAnnotation:pa withTag:101];
}

# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 100) {
        [textField resignFirstResponder];
        [self findLocationWithTag:textField.tag];
    } else if (textField.tag == 101) {
        [textField resignFirstResponder];
        [self findLocationWithTag:textField.tag];
    }
    
    return YES;
}

# pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
        polylineRenderer.fillColor = [UIColor redColor];
        polylineRenderer.strokeColor = [UIColor redColor];
        polylineRenderer.lineWidth = 5;
        return polylineRenderer;
    }
    else
    {
        return  nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        NSLog(@"x is %f", annotationView.center.x);
        NSLog(@"y is %f", annotationView.center.y);
        
        CGPoint dropPoint = CGPointMake(annotationView.center.x, annotationView.center.y);
        CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:dropPoint toCoordinateFromView:annotationView.superview];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
        if ([((MyAnnotation *)(annotationView.annotation)).title isEqualToString:@"Start Point"]) {
            [self getAddressFromLocation:location withTag:100];
        } else {
            [self getAddressFromLocation:location withTag:101];
        }
        [annotationView.annotation setCoordinate:newCoordinate];
        
    } else if (newState == MKAnnotationViewDragStateDragging) {
        NSLog(@"xxxx is %f", annotationView.center.x);
        NSLog(@"yyyy is %f", annotationView.center.y);
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        // [self addObserver:pav forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        pav.draggable = YES;
        pav.canShowCallout = YES;
    }
    else
    {
        pav.annotation = annotation;
    }
    
    return pav;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"value changed");
    // CGPoint position = myAnnotationView.center;
    //... here take  myAnnotationView.centerOffset into consideration to get the correct coordinate
    // CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:position toCoordinateFromView:self.superview];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated");
}

# pragma mark - show alert view methods

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
