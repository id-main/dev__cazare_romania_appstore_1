//
//  UIImage+Strechable.h
//  VirtualCards
//
//  Created by Nicolae Oprea on 9/2/13.
//  Copyright (c) 2013 Actives Soft SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Strechable)
//un fel de 9-patch, dar na apple nu stie 9 patch tre sa le intinzi tu
+(UIImage*)streachebleImageWithName:(NSString*) image_name;
@end
