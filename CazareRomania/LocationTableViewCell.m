//
//  LocationTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 07/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "LocationTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation LocationTableViewCell
@synthesize locationSep;

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
    [locationSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [locationSep setFrame:CGRectMake(0, self.contentView.frame.size.height - 0.5f, self.contentView.frame.size.width, 0.5f)];
    locationSep.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
