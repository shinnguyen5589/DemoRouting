//
//  MyAnnotation.m
//  DemoRouting
//
//  Created by Zdc006-Hoang Dung on 11/26/15.
//  Copyright © 2015 Test. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (void)changeCoordinate:(CLLocationCoordinate2D)_coordinate {
    self.coordinate = _coordinate;
}

@end
