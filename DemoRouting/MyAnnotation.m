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

- (NSString *)subtitle {
    return nil;
}

- (NSString *)title {
    return nil;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate = coord;
    return self;
}

- (CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
    
    //if (self.delegate respondsToSelector:@selector(mapAnnotationCoordinateHaveChanged))
        // [self.delegate performSelector(@selector(mapAnnotationCoordinateHaveChanged))];
}


@end
