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
@interface StartViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,SMCalloutViewDelegate> {
    MKNetworkEngine *engine;    //engine de request web get post
    IBOutlet UIButton *Lupa;    // buton lupa de search
    IBOutlet CustomTextField *searchBar; //textul de cautare
    IBOutlet UIButton *butonMeniuSus;   // buton meniu filtre
    IBOutlet UIActivityIndicatorView *IndicatorIncarcaDate; //indicator load date
    NSArray* dataSource;
    NSArray *searchResults;
    CLGeocoder *reverseGeocoder;
    SMCalloutView *calloutView;
    MKMapView *mapView;
    NSMutableArray *pins;
    int idAnn;
    NSString *searchBarString;
    MBProgressHUD *localizeHUD;
    bool semaphore;
    
}
@property (nonatomic, retain)  CLGeocoder *reverseGeocoder;
@property(nonatomic, retain)IBOutlet UITableView *TabelMeniu;
@property(nonatomic, retain) IBOutlet UIView * searchView;
@property(nonatomic, retain) IBOutlet UIView * filtreView;

@property(nonatomic, retain) IBOutlet UIButton *Lupa;
@property(nonatomic, retain) IBOutlet CustomTextField *searchBar; // text dupa care se face cautarea * invizibil la start
@property (nonatomic, assign) bool isFiltered; //cautarea e filtrata
@property(nonatomic, retain)IBOutlet UIButton *ButonMareAscuns;    // buton care curata search si-l ascunde
@property(nonatomic, retain) IBOutlet UIButton *Localizeazama;
@property (nonatomic,strong) IBOutlet UITableView* table; //tabel principal dupa care se face cautarea * invizibil la start
@property(nonatomic, retain) IBOutlet UIButton *butonMeniuSus;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *IndicatorIncarcaDate;
@property(nonatomic, retain) IBOutlet UIButton *butonPensiune;
@property (nonatomic,retain) NSArray* mapPois;
@property (nonatomic,retain) NSString* sid;
@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) NSMutableArray *annoations;
@property (nonatomic,retain) NSMutableArray *FullAnnotations; //copie + id
@property (nonatomic,retain) NSMutableArray *toateRezultatele; //returneaza tot ce exista prin filtre si incarca tabelul pentru cautare
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet NSDictionary *toatefiltrele;
@property (nonatomic, strong) UIGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSDictionary *room_icons;
-(void)checkCmd :(NSString*)stringPentruServer;
-(void)PROCESEAZA_CMD :(NSString *)margini :(NSString*)stringPentruServer :(NSString*)cmd_local;
@property (nonatomic,retain) NSString *stringPentruServer;
@property (assign) int fullId;
@property (assign) int cateSearch;
-(BOOL)MyStringisEmpty:(NSString *)str;
- (void)goToMarker;
@property (nonatomic, assign)CLLocationCoordinate2D myNorthEast, mySouthWest;
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRAN;

@end

//1. -(void)preiaFiltre_Ecran1 ->REQ1 rezultat_REQ1
//2. -(void)preiaHarta_Ecran1  ->REQ2 rezultat_REQ2

@interface MapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property int idAnn;
@end

@interface CustomPinAnnotationView : MKPinAnnotationView
@property (strong, nonatomic) SMCalloutView *calloutView;
@property int idAnn;

@end
