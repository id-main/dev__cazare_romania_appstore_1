//
//  CommentTableViewCell.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 12/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *touristName;
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinkHeartImage;
@property (weak, nonatomic) IBOutlet UIImageView *grayHeartImage;
@property (weak, nonatomic) IBOutlet UITextView *positiveComment;
@property (weak, nonatomic) IBOutlet UITextView *negativeComment;

@end
