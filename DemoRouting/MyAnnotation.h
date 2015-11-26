//
//  MyAnnotation.h
//  DemoRouting
//
//  Created by Zdc006-Hoang Dung on 11/26/15.
//  Copyright © 2015 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
     CLLocationCoordinate2D coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
