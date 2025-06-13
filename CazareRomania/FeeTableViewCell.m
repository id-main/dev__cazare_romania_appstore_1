//
//  FeeTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 07/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "FeeTableViewCell.h"
#import <Quartzcore/QuartzCore.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation FeeTableViewCell

@synthesize arrowImage, roomTypeIcon, roomPriceLabel, numberOfRoomsView, iconView, separator, feesSep;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [numberOfRoomsView.layer setCornerRadius:5];
    [numberOfRoomsView.layer setBorderColor:UIColorFromRGB(0xe5e5e5).CGColor];
    [numberOfRoomsView.layer setBorderWidth:0.5f];
    
    [separator setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    [separator setFrame:CGRectMake(separator.frame.origin.x+ 0.5, separator.frame.origin.y , 0.5, separator.frame.size.height)];
    [feesSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    [feesSep setFrame:CGRectMake(0, self.contentView.frame.size.height - 0.5f, self.contentView.frame.size.width, 0.5f)];
    
    feesSep.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
