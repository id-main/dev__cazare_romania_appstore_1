//
//  PensionTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 09/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PensionTableViewCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UIImageView *thumbImage;
@property(nonatomic, strong) IBOutlet UILabel * title;
@property(nonatomic, strong) IBOutlet UIView * starsView;
@property(nonatomic, strong) IBOutlet UILabel * priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *pensionSep;

@end
