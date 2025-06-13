//
//  DropDownTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 08/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "DropDownTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation DropDownTableViewCell

@synthesize noOfRooms, checkImage;
- (void)awakeFromNib
{
    // Initialization code
    
//    [sepDropDown setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
//    
//    [sepDropDown setFrame:CGRectMake(0, 48.5f, self.contentView.frame.size.width, 0.5f)];
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [noOfRooms setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [noOfRooms setTextColor:UIColorFromRGB(0x666666)];

    // Configure the view for the selected state
}

@end
