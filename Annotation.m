//  CazareRomania
//  Created by Ioan Ungureanu on 4/16/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.

#import "Annotation.h"

@implementation Annotation



#pragma mark -
#pragma mark Getters and setters
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize objectX;
@synthesize OBIECTId = _OBIECTId;
@synthesize imageURL = _imageUrl;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description :(int)OBIECTId :(NSURL *)imageURL;
{
    self = [super init];
    if (self)
    {
        coordinate = location;
        title = placeName;
        subtitle = description;
        _OBIECTId = OBIECTId;
        _imageUrl = imageURL;
    }
    
    return self;
}


-(id)initWithLatitude:(float)lat andLongitude:(float)lon
            placeName:(NSString *)placeName
          description:(NSString *)description :(int)OBIECTId :(NSURL *)imageURL;
{
    self = [super init];
    if (self)
    {
        coordinate = CLLocationCoordinate2DMake(lat,lon);;
        title = placeName;
        subtitle = description;
        _OBIECTId = OBIECTId;
        _imageUrl = imageURL;
    }
    
    return self;
}

@end
