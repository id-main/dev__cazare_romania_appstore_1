//
//  EcranListaPensiuniViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 15/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseMaster.h"

@interface EcranListaPensiuniViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *myList;
    DataMasterProcessor * controller;
    NSIndexPath *selectedIndexPath;
    
}

@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIButton *requestButton;
@property(nonatomic, strong) IBOutlet UITableView *listTableView;
@property(nonatomic, strong) IBOutlet UIButton *bottomRequestButton;
@property(nonatomic, strong) IBOutlet UILabel *screenTitle;
@property(nonatomic, strong) IBOutlet UIScrollView * mainScrollView;
@property(nonatomic, strong) IBOutlet UIView * bottomRequestView;
@property(nonatomic, strong) NSArray *myList;
@property(nonatomic, strong) IBOutlet UIView *requestView;
@property(nonatomic, strong) IBOutlet UILabel * requestLabel;
@property(nonatomic, strong) IBOutlet UILabel * backLabel;
@property(nonatomic, strong) IBOutlet UIView * greenBorder;

@end
