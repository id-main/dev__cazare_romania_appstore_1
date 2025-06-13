//
//  EcranFavoriteViewController.h
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcranFavoriteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    NSDictionary * myJson;
    NSMutableArray * favoritesArray;
    CLLocationCoordinate2D  pensionCoordinate;
    CLLocationManager *locationManager;
     NSMutableArray  * heightForRow, *resizedPaths;
}
@property(nonatomic, strong) IBOutlet UIView *backView;
@property(nonatomic, strong) IBOutlet UILabel *backLabel;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UITableView *favoritesListTableView;
@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, readwrite) CLLocationCoordinate2D pensionCoordinate;
@property(nonatomic,strong) NSDictionary *myJson;
@property (nonatomic, strong) IBOutlet NSMutableDictionary *pensiuneaSursa;
@property (nonatomic, strong) IBOutlet NSMutableDictionary *locatieUserSursa;
@property (nonatomic,retain) NSString *stringSursaRuta;// indica localitatea aleasa pt ruta sau din istoric punct de start
@property(nonatomic,strong) NSMutableArray *copieFavorite;
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRAN;
@end
