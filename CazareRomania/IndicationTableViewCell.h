//
//  IndicationTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicationTableViewCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *positionLabel;
@property(nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property(nonatomic, strong) IBOutlet UILabel *labeltopcell;
@property(nonatomic, strong) IBOutlet UILabel *labelbottomcell;


@end
