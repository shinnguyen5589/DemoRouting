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
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (void)changeCoordinate:(CLLocationCoordinate2D)coordinate;

@end
