//
//  CustomTextField.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 04/06/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self rectForBounds:bounds];
}

//here 40 - is your x offset
- (CGRect)rectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 3);
}

// override rightViewRectForBounds method:
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = CGRectMake(bounds.origin.x + bounds.size.width -25, (bounds.size.height -18) /2, 18, 18);
    return rightBounds ;
}

@end
