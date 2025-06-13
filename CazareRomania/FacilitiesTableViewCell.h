//
//  FacilitiesTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 07/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacilitiesTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView * icon;
@property(nonatomic, strong) IBOutlet UILabel * label;
@property(nonatomic, strong) IBOutlet UIImageView * next;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
