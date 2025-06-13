//
//  EcranPensiune.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DataBaseMaster.h"
#import "AFImageViewer.h"



@interface EcranPensiuneViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,AFImageViewerDelegate>{
    MKNetworkEngine *engine;
    NSDictionary *myJson;
    NSArray *feesArray, *locationsArray, *dropDownOptions;
    NSMutableArray * facilitiesArray;
    UIColor *headerColor, *bannerColor;
    bool block;
    int feeIndex, numberOfRooms;
    CGFloat  increaseCellBy;
    NSMutableArray * expandedPaths;
    NSMutableArray *descriptionHeightForRow, *expandedCellHeight;
    MFMailComposeViewController *mailVC;
    DataMasterProcessor * controller;
    NSString *backString;
   CGRect viewerPortraitFrame, viewerLandscapeFrame, mainScrollViewPortraitFrame;
    NSArray *activities;
    NSDictionary * room_icons;
    NSArray * thisPensionFacilitiesArray;
    
}


@property (nonatomic,strong) IBOutlet  UIImageView * headerView;
@property (nonatomic,strong) IBOutlet  UIButton * shareButton;
@property (nonatomic,strong) IBOutlet   UIView  * titleView;
@property (nonatomic,strong) IBOutlet  UILabel * pensionTitleLabel;
@property (nonatomic,strong) IBOutlet  UIView * bubleView;
@property (nonatomic,strong) IBOutlet  UIView * feesView;
@property (nonatomic,strong) IBOutlet  UITableView * feesTableView;
@property (nonatomic,strong) IBOutlet  UIButton * changeDateButton;
@property (nonatomic,strong) IBOutlet  UILabel * todayFees;
@property (nonatomic,strong) IBOutlet  UIScrollView * mainScrollView;
@property (nonatomic,strong) IBOutlet  UIView * bookingView;
@property (nonatomic,strong) IBOutlet  UIButton * callButton;
@property (nonatomic,strong) IBOutlet  UIButton * emailButton;
@property (nonatomic,strong) IBOutlet  UIButton * bookingButton;
@property (nonatomic,strong) IBOutlet  UIView * facilitiesView;
@property (nonatomic,strong) IBOutlet  UITableView * facilitiesTableView;
@property (nonatomic,strong) IBOutlet  UILabel * facilitiesLabel;
@property (nonatomic,strong) IBOutlet  UIWebView * descriptionWebView;
@property (nonatomic,strong) IBOutlet  UIView * descriptionView;
@property (nonatomic,strong) IBOutlet  UIView * seeComments;
@property (nonatomic,strong) IBOutlet  UIView * locationsView;
@property (nonatomic,strong) IBOutlet  UILabel * locationsLabel;
@property (nonatomic,strong) IBOutlet  UITableView * locationsTableView;
@property (nonatomic, strong) IBOutlet UITextView * adressTextView;
@property (nonatomic, strong) IBOutlet UIView * dropDownView;
@property (nonatomic, strong) IBOutlet UITableView *dropDownTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *dropDownScrollView;
@property (nonatomic, strong) IBOutlet UIView * hideView;
@property (nonatomic, strong) IBOutlet UIView * backView;
@property (nonatomic, strong) IBOutlet UILabel * backLabel;
@property (nonatomic, strong) IBOutlet UIButton * backButton;
@property (nonatomic, strong) IBOutlet NSDictionary *myJson;
@property (nonatomic, strong) NSString *backString;
@property (nonatomic, strong) IBOutlet AFImageViewer *photoViewer;
@property (nonatomic, strong) IBOutlet UIView * backFromMapView;
@property (nonatomic, strong) IBOutlet UIView * backFromPension;
@property (nonatomic, strong) IBOutlet UIView * seeComentsParentView;
@property (nonatomic, strong) IBOutlet UILabel * seeComentsLabel;
@property (nonatomic, strong) IBOutlet UILabel * freeRooms;
@property (nonatomic, strong) IBOutlet UIButton * mapButton;

@property(nonatomic, strong) IBOutlet UIView * greenBorder;


@property(nonatomic, strong) IBOutlet UIView * todayOfferSep;
@property(nonatomic, strong) IBOutlet UIView * facilitiesSep;
@property(nonatomic, strong) IBOutlet UIView * toVisitSep;

@end
