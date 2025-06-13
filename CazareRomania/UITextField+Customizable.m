//
//  UITextField+Customizable.m
//  VirtualCards
//
//  Created by Nicolae Oprea on 9/3/13.
//  Copyright (c) 2013 Actives Soft SRL. All rights reserved.
//

#import "UITextField+Customizable.h"
#import "UIImage+Strechable.h"

@implementation UITextField (Customizable)

//45.25
-(void)loadMainTheme{
    UIView *paddingViewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingViewLeft;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingViewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.rightView=paddingViewRight;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    self.background = [UIImage streachebleImageWithName:@"textfield_nrm.png"];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica"
                                    size:17 ];
    [self setFont:font];
}

//- (BOOL)becomeFirstResponder {
//    BOOL outcome = [super becomeFirstResponder];
//    if (outcome) {
//        self.background = [UIImage streachebleImageWithName:@"textfield_sel.png"];
//    }
//    return outcome;
//}
//
//- (BOOL)resignFirstResponder {
//    NSLog(@"%s",__func__);
//    BOOL outcome = [super resignFirstResponder];
//    if (outcome) {
//        self.background = nrmImg;
//    }
//    return outcome;
//}


@end
