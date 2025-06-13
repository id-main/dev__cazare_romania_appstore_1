//
//  EcranObiectiveViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 09/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseMaster.h"
#import "AFImageViewer.h"

@interface EcranObiectiveViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AFImageViewerDelegate>{
    MKNetworkEngine *engine;
    NSDictionary * myJson;
    NSArray * nearbyPlacesArray;
    DataMasterProcessor * controller;
    NSString *backString;
    CGRect viewerPortraitFrame, viewerLandscapeFrame, mainScrollViewPortraitFrame;
}

@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *bubleView;
@property (nonatomic, strong) IBOutlet UITextView * addressTextView;
@property (nonatomic, strong) IBOutlet UIView * addressView;
@property (nonatomic, strong) IBOutlet UIView * descriptionView;
@property (nonatomic, strong) IBOutlet UIWebView * descriptionWebView;
@property (nonatomic, strong) IBOutlet UIView * nearbyPlacesView;
@property (nonatomic, strong) IBOutlet UITableView * nearbyPlacesTable;
@property (nonatomic, strong) IBOutlet UILabel * nearbyPlacesLabel;
@property (nonatomic, strong) IBOutlet NSDictionary * myJson;
@property (nonatomic, strong) IBOutlet UILabel * backTitle;
@property (nonatomic,strong) NSString *backString;
@property (nonatomic, strong) IBOutlet AFImageViewer *myImageViewer;
@property (nonatomic, strong) IBOutlet UIView *backFromMapView;
@property (nonatomic, strong) IBOutlet UILabel * bookingLabel;
@property (nonatomic, strong) IBOutlet UIButton * backToMap;
@property (nonatomic, strong) IBOutlet UIView * greenBorder;



@end
