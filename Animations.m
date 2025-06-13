//
//  Animations.m
//  BogdanDotCode
//
//  Created by Andrei Stefan on 5/26/11.
//  Copyright 2011 IMC. All rights reserved.
//

#import "Animations.h"


@implementation Animations

+(int)getScreenWidth
{
//    NSLog(@"%s",__FUNCTION__);
    CGRect cgRect =[[UIScreen mainScreen] bounds];
    CGSize cgSize = cgRect.size;
    return cgSize.width;
}

+(int)getScreenHeight
{
//    NSLog(@"%s",__FUNCTION__);
    CGRect cgRect =[[UIScreen mainScreen] bounds];
    CGSize cgSize = cgRect.size;
    return cgSize.height;
}
+(int)getViewWith:(UIView*)target
{
//    NSLog(@"%s",__FUNCTION__);
    CGRect cgRect=[target bounds];
    CGSize cgSize = cgRect.size;
    return cgSize.width;
}


+(int)getViewHeight:(UIView*)target
{
    //    NSLog(@"%s",__FUNCTION__);
    CGRect cgRect=[target bounds];
    CGSize cgSize = cgRect.size;
    return cgSize.height;
}


+(int):(UIView*)target
{
//    NSLog(@"%s",__FUNCTION__);
    CGRect cgRect=[target bounds];
    CGSize cgSize = cgRect.size;
    return cgSize.height;
}


+(void)moveout:(UIView*)viewToMove animTime:(double)timeToAnimate
{
//    NSLog(@"%s",__FUNCTION__);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeToAnimate];
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0, [Animations getViewHeight:viewToMove]+100);
    viewToMove.transform = transform1;
    [UIView commitAnimations];
    
}

//slides the view out to the lateral
+(void)slideout:(UIView*)viewToMove animTime:(double)timeToAnimate
{
//    NSLog(@"%s",__FUNCTION__);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeToAnimate];
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation([Animations getViewWith:viewToMove], 0);
    viewToMove.transform = transform2;
    [UIView commitAnimations];
    
}

//brings the view to the screen
+(void)movein:(UIView*)viewToMove animTime:(double)timeToAnimate
{
//    NSLog(@"%s",__FUNCTION__);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeToAnimate];
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0, 0);
    viewToMove.transform = transform1;
    [UIView commitAnimations];
    
}




+(void)slideinFromLeft:(UIView*)viewToMove animTime:(double)timeToAnimate
{
//    NSLog(@"%s",__FUNCTION__);
    
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeToAnimate];
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(-1*([Animations getViewWith:viewToMove]), 0);
//    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(-2000, 0);
    viewToMove.transform = transform1;
    [UIView commitAnimations];
    //[Animations movein:viewToMove animTime:timeToAnimate];
    
    
}

+(void)slideinFromRight:(UIView*)viewToMove animeTime:(double)timeToAnimate
{
//    NSLog(@"%s",__FUNCTION__);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeToAnimate];
    
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(([Animations getViewWith:viewToMove]), 0);
//    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(2000, 0);
    viewToMove.transform = transform1;
    [UIView commitAnimations];
   // [Animations movein:viewToMove animTime:timeToAnimate];
    
}

@end
