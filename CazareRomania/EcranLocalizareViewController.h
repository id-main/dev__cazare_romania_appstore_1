//
//  StartViewController.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMCalloutView.h"
#import "CustomTextField.h"
#import "MBProgressHUD.h"
@interface EcranLocalizareViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,SMCalloutViewDelegate> {
    MKNetworkEngine *engine;    //engine de request web get post
    IBOutlet UIButton *Lupa;    // buton lupa de search
    IBOutlet CustomTextField *searchBar; //textul de cautare
    
    IBOutlet UIButton *butonMeniuSus;   // buton meniu
    //    IBOutlet UIActivityIndicatorView *IndicatorIncarcaDate; //indicator load date
    NSArray* dataSource;
    NSArray *searchResults;
    CLGeocoder *reverseGeocoder;
    
    MKMapView *mapView;
    NSMutableArray *pins;
    int idAnn;
    NSString *searchBarString;
    
    //this used new
    NSDictionary *myJson;
    MKPointAnnotation * pensionAnn, *userAnn;
    CLLocationCoordinate2D  pensionCoordinate;
    MKCoordinateRegion initialRegion;
    bool showUser;
    NSMutableArray * indicationsArray;
    NSMutableArray * SugestiiGoogle;
    UITapGestureRecognizer * ascundeLupa;
    MBProgressHUD *localizeHUD;
    bool showOverlay;
    
}
//this used new
@property(nonatomic, strong) IBOutlet UIButton *backbutton;
@property(nonatomic, strong) IBOutlet UIButton *ruteButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, readwrite) CLLocationCoordinate2D pensionCoordinate;
@property (nonatomic, readwrite) CLLocationCoordinate2D googlePlaceCoordinate;
@property(nonatomic,strong) NSDictionary *myJson;
@property(nonatomic,strong) IBOutlet UIView * coordinateView;
@property(nonatomic, strong) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UIButton *routeDetailsButton;
@property(nonatomic, strong) NSMutableArray * indicationsArray;
@property(nonatomic, strong) NSMutableArray * SugestiiGoogle;
@property (weak, nonatomic) IBOutlet UIButton *modificaRuta;
@property (weak, nonatomic) IBOutlet UIButton *butonIstoric;
@property (nonatomic, retain) IBOutlet UIImageView *sageataLeft;
@property (nonatomic, retain) IBOutlet UIImageView *distantaFundal;

// end new

@property (nonatomic, retain)  CLGeocoder *reverseGeocoder;
@property(nonatomic, retain)IBOutlet UITableView *TabelMeniu;
@property(nonatomic, retain) IBOutlet UIButton *Lupa;
@property(nonatomic, retain) IBOutlet CustomTextField *searchBar; // text dupa care se face cautarea * invizibil la start
@property (nonatomic, assign) bool isFiltered; //cautarea e filtrata
@property(nonatomic, retain) IBOutlet UIButton *ButonMareAscuns2;    // buton care curata search si-l ascunde
@property(nonatomic, retain) IBOutlet UIButton *Localizeazama;
@property (nonatomic,strong) IBOutlet UITableView* table; //tabel principal dupa care se face cautarea * invizibil la start
@property(nonatomic, retain) IBOutlet UIButton *butonMeniuSus;
//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *IndicatorIncarcaDate;
@property(nonatomic, retain) IBOutlet UIButton *butonPensiune;
@property (nonatomic,retain) NSArray* mapPois;
@property (nonatomic,retain) NSString* sid;
@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) NSMutableArray *annoations;
@property (nonatomic,retain) NSMutableArray *FullAnnotations; //copie + id
@property (nonatomic,retain) NSMutableArray *toateRezultatele; //returneaza tot ce exista prin filtre si incarca tabelul pentru cautare
@property (nonatomic, strong) IBOutlet NSDictionary *toatefiltrele;

@property (nonatomic,retain) NSString *stringPentruGoogle;
@property (nonatomic,retain) NSString *stringSursaRuta;// indica localitatea aleasa pt ruta sau din istoric punct de start

@property (assign) int fullId;
-(BOOL)MyStringisEmpty:(NSString *)str;
-(void)PROCESEAZA_REFERINTA_GOOGLE :(NSString *) referinta :(NSMutableDictionary *)sursa;
@property (nonatomic, strong) IBOutlet NSMutableDictionary *pensiuneaSursa;
@property (nonatomic,retain) IBOutlet NSMutableDictionary *locatieUser;
@property (nonatomic) bool showOverlay;
@property (nonatomic,retain) NSString *dinceEcranvine;
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRAN;

@end

//1. -(void)preiaFiltre_Ecran1 ->REQ1 rezultat_REQ1
//2. -(void)preiaHarta_Ecran1  ->REQ2 rezultat_REQ2



