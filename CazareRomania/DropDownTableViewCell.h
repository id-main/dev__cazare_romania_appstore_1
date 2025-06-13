//
//  DropDownTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 08/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noOfRooms;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UIView *sepDropDown;

@end
