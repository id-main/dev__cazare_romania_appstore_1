//
//  EcranComentariiViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 12/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcranComentariiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    NSArray *commentsArray;
    NSMutableArray * resizedPaths;
    NSMutableArray *heightForRow;
    NSDictionary *myJson;
}

@property(nonatomic, strong) IBOutlet UITableView *commentsTableView;
@property(nonatomic, strong) IBOutlet UIImageView *bottomImageView;
@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIView * backView;
@property(nonatomic, strong) IBOutlet UILabel * backLabel;
@property(nonatomic, strong) IBOutlet UILabel * nameLabel;
@property(nonatomic, strong) IBOutlet UIView * nameView;
@property(nonatomic, strong) IBOutlet UIView * noCommentsView;
@property(nonatomic, strong) IBOutlet UITextView * messageTextView;
@property(nonatomic, strong) NSDictionary * myJson;
@property(nonatomic, strong) NSArray * commentsArray;
@property(nonatomic, strong) IBOutlet UIView * messageView;
@property(nonatomic, strong) IBOutlet UIView *messageTextParentView;
@property(nonatomic, strong) IBOutlet UITextView *messageText;
@property(nonatomic, strong) IBOutlet UIImageView *commentsIcon;
@property(nonatomic, strong) IBOutlet UILabel * commentPageTitle;
@property(nonatomic, strong) IBOutlet UIView * greenBorder;
@property(nonatomic, strong) IBOutlet UITextView * noCommentsTextView;
@property(nonatomic, strong) IBOutlet UIView * noCommentsParentView;
@end
