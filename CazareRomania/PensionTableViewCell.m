//
//  PensionTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 09/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "PensionTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation PensionTableViewCell
@synthesize thumbImage, starsView, title, priceLabel,distanceLabel, pensionSep;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [pensionSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    [pensionSep setFrame:CGRectMake(0, self.contentView.frame.size.height - 0.5f, self.contentView.frame.size.width, 0.5f)];
    
   pensionSep.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    // Configure the view for the selected state
}

@end
