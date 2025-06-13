//
//  FeeTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 07/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (nonatomic,strong) IBOutlet  UIImageView * roomTypeIcon;
@property (nonatomic,strong) IBOutlet  UILabel * roomPriceLabel;
@property (nonatomic, strong) IBOutlet UIView * numberOfRoomsView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRoomsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIView *feesSep;

@end
