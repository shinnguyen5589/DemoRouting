//
//  MainViewController.h
//  DemoRouting
//
//  Created by Zdc006-Hoang Dung on 11/26/15.
//  Copyright © 2015 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

# pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UITextField *startPointTf;
@property (weak, nonatomic) IBOutlet UITextField *endPointTf;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

# pragma mark - IBAAtions

- (IBAction)startRoute:(UIButton *)sender;

# pragma mark - Class Properties

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *endPoint;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPinAnnotationView *pav;

@end
