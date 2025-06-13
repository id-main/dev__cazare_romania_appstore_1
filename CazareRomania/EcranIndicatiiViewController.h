//
//  EcranIndicatiiViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcranIndicatiiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIPrintInteractionControllerDelegate>{
    NSDictionary * myJson;
    NSMutableArray * indicationsArray;
    NSMutableArray  * heightForRow, *resizedPaths;
    
}

@property(nonatomic, strong) IBOutlet UIView *backView;
@property(nonatomic, strong) IBOutlet UILabel *backLabel;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UITableView *indications;
@property(nonatomic, strong) IBOutlet UIButton *printButton;
@property(nonatomic, strong) NSMutableArray * indicationsArray;
@property (nonatomic,retain) NSString *stringSursaRuta;// indica localitatea aleasa pt ruta sau din istoric punct de start
@property (nonatomic,retain) NSString *stringEndRuta;// indica localitatea aleasa pt ruta sau din istoric punct de start
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRAN;

@end
