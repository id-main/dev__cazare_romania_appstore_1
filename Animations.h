//
//  Animations.h
//  BogdanDotCode
//
//  Created by Andrei Stefan on 5/26/11.
//  Copyright 2011 IMC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Animations : NSObject {
    
}
+(void)moveout:(UIView*)viewToMove animTime:(double)timeToAnimate;
+(void)slideout:(UIView*)viewToMove animTime:(double)timeToAnimate;
+(void)movein:(UIView*)viewToMove animTime:(double)timeToAnimate;

+(void)slideinFromLeft:(UIView*)viewToMove animTime:(double)timeToAnimate;
+(void)slideinFromRight:(UIView*)viewToMove animeTime:(double)timeToAnimate;


@end
