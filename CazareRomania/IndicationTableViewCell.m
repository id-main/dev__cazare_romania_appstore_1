//
//  IndicationTableViewCell.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "IndicationTableViewCell.h"

@implementation IndicationTableViewCell

@synthesize descriptionTextView, positionLabel, labeltopcell,labelbottomcell;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat)textInset {
    return 8.0f;
}
- (CGFloat)marginTop {
    return 18.5f;
}

- (CGFloat)marginBottom {
    return 18.5;
}

- (CGFloat)marginLeft {
    return 30.0f;
}

- (CGFloat)marginRight {
    return 3.0f;
}

// Sets the text and adjusts the frame height
// so that the text view does not scroll
- (void)setContentText:(NSString *)theText {
    self.descriptionTextView.text = theText;
    CGRect frame = self.descriptionTextView.frame;
    CGFloat cHeight = self.descriptionTextView.contentSize.height;
    frame.size.height = cHeight + self.textInset;
    self.descriptionTextView.frame = frame;
}

// Calculates the text views width by subtracting
// the horizontal insets and margins
- (CGFloat)textWidthForOuterWidth:(CGFloat)outerWidth {
    CGFloat textInset = self.textInset * 2;
    CGFloat marginH = self.marginLeft + self.marginRight;
    CGFloat width = outerWidth - marginH;
    CGFloat textWidth = width - textInset;
    return textWidth;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
    // calculate the outer width of the cell
    // based on the tableView style
    CGFloat outerWidth = tableView.frame.size.width;
    if (tableView.style == UITableViewStyleGrouped) {
        // the grouped table inset is 20px on
        // the iPhone and 90px on the iPad
        BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom ==
        UIUserInterfaceIdiomPhone;
        outerWidth -= iPad ? 20.0f : 90.0f;
    }
    CGFloat textInset = self.textInset * 2;
    CGFloat marginV = self.marginTop + self.marginBottom;
    CGFloat textWidth = [self textWidthForOuterWidth:outerWidth];
    // use large value to avoid scrolling
    CGFloat maxHeight = 50000.0f;
    CGSize constraint = CGSizeMake(textWidth, maxHeight);
    CGSize size = [self.descriptionTextView.text
                   sizeWithFont:self.descriptionTextView.font
                   constrainedToSize:constraint
                   lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height + textInset + marginV;
    return height;
}

@end
