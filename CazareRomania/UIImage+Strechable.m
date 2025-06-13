//
//  UIImage+Strechable.m
//  VirtualCards
//
//  Created by Nicolae Oprea on 9/2/13.
//  Copyright (c) 2013 Actives Soft SRL. All rights reserved.
//

#import "UIImage+Strechable.h"

@implementation UIImage (Strechable)

+(UIImage*)streachebleImageWithName:(NSString*) image_name{
    UIImage* strechedImage=[UIImage imageNamed:image_name];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0){
        //top, left, bottom, right
        strechedImage=[strechedImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 6, 20, 6)];
    }else{
        strechedImage=[strechedImage stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    }
    
    return strechedImage;
}

@end
