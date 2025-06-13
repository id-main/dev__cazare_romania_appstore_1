//
//  EcranListaObiectiveViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 15/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseMaster.h"


@interface EcranListaObiectiveViewController : UIViewController{
    NSMutableArray * locationsArray;
    DataMasterProcessor * controller;
    NSArray *myJson;
    NSIndexPath * selectedIndexPath;
    
}

@property(strong, nonatomic) IBOutlet UILabel *screenTitle;
@property(strong, nonatomic) IBOutlet UITableView *listTableView;
@property(strong, nonatomic) IBOutlet UIButton *backButton;
@property(strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property(strong, nonatomic) IBOutlet  NSArray * locationsArray;
@property(strong, nonatomic) IBOutlet NSArray *myJson;
@property(strong, nonatomic) IBOutlet UIView * greenBorder;
@end
