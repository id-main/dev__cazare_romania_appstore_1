//
//  LocationTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 07/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *previewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextImage;
@property (weak, nonatomic) IBOutlet UIView *locationSep;

@end
