//
//  Annotation.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/16/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface Annotation : NSObject <MKAnnotation> {
    NSString *_title;
    NSString *_subtitle;
    CLLocationCoordinate2D _coordinate;
    int _OBIECTId;
    NSURL *_imageUrl;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSURL *imageURL;
@property (assign) int OBIECTId;

@property (nonatomic, retain) id objectX;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description :(int)OBIECTId :(NSURL *)imageURL;

-(id)initWithLatitude:(float)lat andLongitude:(float)lon
            placeName:(NSString *)placeName
          description:(NSString *)description :(int)OBIECTId :(NSURL *)imageURL;
@end
