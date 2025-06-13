//
//  SimpleCheckTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 26/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "SimpleCheckTableViewCell.h"

@implementation SimpleCheckTableViewCell
@synthesize textTitle, cehckImage;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}

@end
