//
//  StartViewController.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
//#import "EcranLocalizareViewController.h"
//#import "Animations.h"
//#import "Annotation.h"
//#import "MKMapView+ZoomLevel.h"
////#import "JPSThumbnailAnnotation.h" // custom images pt map annotations + J ideea red pin
//#import "Ecran4Filtre.h"
//#import "DataBaseMaster.h"
#import "AppDelegate.h"
//#import "EcranPensiune.h"
//#import "EcranObiectiveViewController.h"DIDDRAFG
//#import "SMCalloutView.h"
//#include "ASIHTTPRequest.h"
//#import <QuartzCore/QuartzCore.h>
//#import "SMCalloutView.h"
//#import "EcranListaObiectiveViewController.h"
//#import "EcranListaPensiuniViewController.h"
//#import "EcranFavoriteViewController.h"
//#import "EcranIndicatiiViewController.h"
//#import "MapPoint.h"
#import "EcranLocalizareViewController.h"
#import "Annotation.h"
#import "MKMapView+ZoomLevel.h"
#import <QuartzCore/QuartzCore.h>
#include "ASIHTTPRequest.h"
#import <MapKit/MapKit.h>
#import "EcranIndicatiiViewController.h"
#import "EcranFavoriteViewController.h"

#define ZOOM_LEVEL_14 14
#define ZOOM_LEVEL_7 7
#define ZOOM_LEVEL_1 1
#define Default_pensiuni 1
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define MAP_PADDING 2.1
#define MINIMUM_VISIBLE_LATITUDE 0.01
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface EcranLocalizareViewController ()

@property (nonatomic,strong) IBOutlet UIView *HIDDENview;
@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
-(IBAction)APASAok:(id)sender;
-(IBAction)decodeButton:(id)sender;
@end

@implementation EcranLocalizareViewController
@synthesize Lupa,searchBar, isFiltered, table, butonMeniuSus,ButonMareAscuns2,Localizeazama;

@synthesize segmentedControl;
@synthesize HIDDENview;
@synthesize TabelMeniu;
@synthesize mapView,annoations,FullAnnotations,locationManager,toateRezultatele, toatefiltrele,butonPensiune,stringPentruGoogle;
@synthesize reverseGeocoder, fullId;
@synthesize backbutton, coordinateLabel, ruteButton,myJson,coordinateView;
@synthesize indicationsArray,SugestiiGoogle,pensionCoordinate,googlePlaceCoordinate,modificaRuta,butonIstoric, pensiuneaSursa,locatieUser,stringSursaRuta,sageataLeft,distantaFundal,showOverlay,dinceEcranvine,TITLUECRAN;

//init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //ComNSLog(@"%s",__func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//// incarca date initiale



- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] ;
    }
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return  nil;
        
    }
    if([self.dinceEcranvine isEqualToString:@"pensiune"]) {
        annotationView.image = [UIImage imageNamed:@"red-pin.png"];
    }
    if([self.dinceEcranvine isEqualToString:@"obiectiv"]) {
        annotationView.image = [UIImage imageNamed:@"indicator-portocaliu.png"];
    }
    
    annotationView.annotation = annotation;
    return annotationView;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    CGRect frametemp = self.mapView.frame;
////    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
////        //DO Portrait
////        frametemp.size.height = screenHeight+52;
////        frametemp.size.width = screenWidth;
////        frametemp.origin.y = 52;
////        self.mapView.frame = frametemp;
////    }else{
////        //DO Landscape
////        frametemp.size.height = screenWidth+52 ;
////        frametemp.size.width = screenHeight;
////        frametemp.origin.y = 52;
////        self.mapView.frame = frametemp;
////    }
   self.dinceEcranvine = dinceEcranvine;
    [self verificaButoane];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arataIndicatii:)];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
    {
        if ([overlayToRemove isKindOfClass:[MKPolylineView class]])
        {
            [mapView removeOverlay:overlayToRemove];
        }
    }
    //  if(dinceEcranvine isEqualToString:@"pensiune"
    
    //ComNSLog(@"myjs%@", myJson);
    
    // if labelView is not set userInteractionEnabled, you must do so
    [self.coordinateLabel setUserInteractionEnabled:YES];
    [self.coordinateLabel addGestureRecognizer:gesture];
    
    
    
    ////  dimensiuni harta
    //    [ mapView setFrame:CGRectMake(0,  60, 320,   [[UIScreen mainScreen] bounds].size.height )];
    //    [[UIScreen mainScreen] bounds].size.height - 60)];
    //// TEXT CAUTARE
    
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    
    
    searchBar.hidden=YES;
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 28)];
    
    [searchBar addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    searchBar.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    searchBar.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    searchBar.borderStyle = UITextBorderStyleNone;
    searchBar.layer.borderWidth = 0.5f;
    searchBar.layer.borderColor = [UIColorFromRGB(0xe5e5e5) CGColor];
    searchBar.layer.cornerRadius = 5.0f;
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    
    //// MANAGER LOCATIE PRINCIPAL
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    
    //// ADD GESTURE PENTRU A DETECTA DACA S-A MISCAT HARTA
    //    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    //   [panRec setDelegate:self];
    // [mapView addGestureRecognizer:panRec];
    
    
    ///// not here    [self AduceDateInitiale];
    //   just in case you need  searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    //this new
    self.myJson = myJson;
    //ComNSLog(@"myjson ---%@",myJson);
    //ComNSLog(@"gps coordinate---%@",myJson[@"gps"]);
    ruteButton.layer.cornerRadius = 5.0;
    ruteButton.layer.masksToBounds = YES;
    pensionCoordinate = CLLocationCoordinate2DMake([myJson[@"gps"][0] floatValue],[myJson[@"gps"][1] floatValue]);
    pensionAnn = [[MKPointAnnotation alloc] init];
    pensionAnn.coordinate = pensionCoordinate;
    [mapView addAnnotation:pensionAnn];
    //    [mMapView setCenterCoordinate:pensionCoordinate zoomLevel:ZOOM_LEVEL_7 animated:YES];
    [coordinateLabel setText:[NSString stringWithFormat:@"%f, %f",pensionCoordinate.latitude, pensionCoordinate.longitude ]];
    
    //ComNSLog(@"user location---%f,%f",locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    //ComNSLog(@"pension coordinate---%f,%f",pensionCoordinate.latitude, pensionCoordinate.longitude);
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    //    [mMapView setRegion:initialRegion animated:YES];
   
    
    //this is first center on map an updated method JOHN review
    CLLocationCoordinate2D track;
    track.latitude = pensionCoordinate.latitude;
    track.longitude = pensionCoordinate.longitude;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = track;
    [mapView setCenterCoordinate:pensionCoordinate zoomLevel:ZOOM_LEVEL_14 animated:YES];
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];

    
    
//    
//    MKCoordinateRegion region;
//    region.center = pensionCoordinate;
//    MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
//    region.span = span;
//    [mapView setCenterCoordinate:pensionCoordinate zoomLevel:ZOOM_LEVEL_14 animated:YES];
//    [mapView setRegion:region];
    
    initialRegion = mapView.region;
    
    [mapView setShowsUserLocation:YES];
       CLLocationCoordinate2D centerCoord = {locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude};
    
    //ComNSLog(@"centerCoord %f",centerCoord.latitude );
    //ComNSLog(@"centerCoord 2 %f", centerCoord.longitude );
    //ComNSLog(@"pensiuneCord %@", myJson[@"gps"][0] );
    //ComNSLog(@"pensiuneCord 2 %@", myJson[@"gps"][1] );
    pensiuneaSursa = [[NSMutableDictionary alloc]init];
    NSString *latPensiune = [[NSString alloc]init];
    NSString *lngPensiune = [[NSString alloc]init];
    latPensiune =[NSString stringWithFormat:@"%f",[myJson[@"gps"][0] floatValue]];
    lngPensiune =[NSString stringWithFormat:@"%f",[myJson[@"gps"][1] floatValue]];
    [pensiuneaSursa setValue:latPensiune forKey:@"lat"];
    [pensiuneaSursa setValue:lngPensiune forKey:@"lng"];
    locatieUser = [[NSMutableDictionary alloc]init];
    self.modificaRuta.hidden =YES;
    self.butonIstoric.hidden=YES;
    self.stringSursaRuta = [[NSString alloc]init];
    self.sageataLeft.hidden=YES;
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelGlobal.CMD_LOCATIE =nil;
    
    [coordinateView setBackgroundColor:[UIColor blackColor]];
    [coordinateView setAlpha:0.7f];
    [coordinateView.layer setBorderColor:[UIColor colorWithWhite:0.0f alpha:0.7f].CGColor];
    [coordinateView.layer setBorderWidth:1.0f];
    
    [coordinateLabel setTextColor:[UIColor whiteColor]];
    [coordinateLabel setTextAlignment:NSTextAlignmentCenter];
    [coordinateLabel setFrame:CGRectMake(coordinateLabel.frame.origin.x+20, coordinateLabel.frame.origin.y, coordinateLabel.frame.size.width -20, coordinateLabel.frame.size.height)];;
    
    [sageataLeft setHidden:YES];
    UIImage* localizareOff = [UIImage imageNamed:@"track-icon-off_j.png"];
    UIImage* localizareOn = [UIImage imageNamed:@"track-icon-on_j.png"];
    [Localizeazama setBackgroundImage:localizareOn forState:UIControlStateSelected];
    [Localizeazama setBackgroundImage:localizareOff forState:UIControlStateNormal];
    Localizeazama.selected =NO;
  
    TITLUECRAN.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    
    backbutton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    backbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backbutton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    /* printButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    printButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    printButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ; */
    
}



-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    CGRect frametemp = self.mapView.frame;
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
      [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 *searchResults.count)];
      [self.table setNeedsDisplay];
  
    }
    else{
         //DO Landscape
       [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 *searchResults.count)];
        [self.table setNeedsDisplay];
     
        //        [distantaFundal setFrame:CGRectMake(distantaFundal.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - distantaFundal.frame.size.height - 15, distantaFundal.frame.size.width,  distantaFundal.frame.size.height)];
        //
        //        [sageataLeft setFrame:CGRectMake(sageataLeft.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - sageataLeft.frame.size.height -20, sageataLeft.frame.size.width,  sageataLeft.frame.size.height)];
        //        [coordinateLabel setFrame:CGRectMake(coordinateLabel.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - coordinateLabel.frame.size.height - 15, coordinateLabel.frame.size.width,  coordinateLabel.frame.size.height)];
    }
}

-(void)verificaSearch {
    //ComNSLog(@"curata");
    //[self   curataText];
    if ([searchBar.text isEqualToString:@""]) {
        [self hideLupa];
        backbutton.hidden =NO;
    } else {
        searchBar.text =@"";
        searchBar.placeholder = searchBar.placeholder;
        [self textFieldDidChange1:searchBar];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //ComNSLog(@"will appear");
    
    
    
  
    
    
    [self verificaButoane];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arataIndicatii:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.coordinateLabel setUserInteractionEnabled:YES];
    [self.coordinateLabel addGestureRecognizer:gesture];
    
    
    self.stringPentruGoogle = [[NSString alloc]init];
    self.myJson = myJson;
    //       //ComNSLog(@"gps coordinate in 2 ---%@",myJson[@"gps"]);
    pensionCoordinate = CLLocationCoordinate2DMake([myJson[@"gps"][0] floatValue],[myJson[@"gps"][1] floatValue]);
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *cmd_local=  appDelGlobal.CMD_LOCATIE;
    //    appDelGlobal.CMD_LOCATIE =@"LocatieUser";
    //      appDelGlobal.CMD_LOCATIE =@"Altalocatie";
    
    self.stringPentruGoogle = appDelGlobal.stringPentruGoogle;
    self.locatieUser = appDelGlobal.userLocatie;
    if([cmd_local isEqual:@"Altalocatie"]) {
        if(self.stringPentruGoogle.length !=0 ) {
            //ComNSLog(@"the very J");
            [self.mapView removeOverlays:self.mapView.overlays];
            for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
            {
                if ([overlayToRemove isKindOfClass:[MKPolylineView class]])
                {
                    [mapView removeOverlay:overlayToRemove];
                }
            }
            
            [self PROCESEAZA_REFERINTA_GOOGLE:self.stringPentruGoogle :pensiuneaSursa];
        }
    } else if([cmd_local isEqual:@"LocatieUser"]) {
        if ([[locatieUser objectForKey:@"lat"]floatValue] >0  && [[locatieUser objectForKey:@"lng"] floatValue]>0){
            //ComNSLog(@"baboocha");
            [self.mapView removeOverlays:self.mapView.overlays];
            for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
            {
                if ([overlayToRemove isKindOfClass:[MKPolylineView class]])
                {
                    [mapView removeOverlay:overlayToRemove];
                }
            }
            
            [self DianaDeseneazaRutaFrumos:locatieUser :pensiuneaSursa];
            
        }
    }
    
    if (appDelGlobal.startLocatie) {
        self.stringSursaRuta = appDelGlobal.startLocatie;
        //ComNSLog(@"appDelGlobal.startLocatie %@",appDelGlobal.startLocatie);
    }
    
    
    //    ascundeLupa = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLupaGest:)];
    
    //    self.ButonMareAscuns.hidden =YES;
    //    [self.view addGestureRecognizer:ascundeLupa];
    showUser = NO;
}

-(void)hideLupaGest:(UITapGestureRecognizer *)recogn{
    [self hideLupa];
}

//- (void)viewWillAppearx:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    //ComNSLog(@"%s",__func__);
//
//
//    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
//        //// BUTON LOCALIZARE
//        UIImage* localizareOff = [UIImage imageNamed:@"track-icon-on_j.png"];
//        UIImage* localizareOn = [UIImage imageNamed:@"track-icon-off_j.png"];
//        [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - Localizeazama.frame.size.height - 15, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
//        [Localizeazama setBackgroundImage:localizareOn forState:UIControlStateSelected];
//        [Localizeazama setBackgroundImage:localizareOff forState:UIControlStateNormal];
//    }
//    else{
//        //// BUTON LOCALIZARE
//        UIImage* localizareOff = [UIImage imageNamed:@"track-icon-on_j.png"];
//        UIImage* localizareOn = [UIImage imageNamed:@"track-icon-off_j.png"];
//        [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.width - Localizeazama.frame.size.height - 15, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
//        [Localizeazama setBackgroundImage:localizareOn forState:UIControlStateSelected];
//        [Localizeazama setBackgroundImage:localizareOff forState:UIControlStateNormal];
//    }
//
//    //self.navigationController.navigationBar.hidden = YES;
//    // self.HIDDENview.hidden =YES;
//    // [self.view addSubview:HIDDENview];
//    //ComNSLog(@"deviceLocation %@", [self deviceLocation]);
//    // Read / set / Store the location
//
//    //  [self MARGINIMAP];
//    for (id<MKAnnotation> annotation in mapView.annotations) {
//        [mapView removeAnnotation:annotation];
//    }
//
//    /////// inaltime tabel
//    [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * toateRezultatele.count)];
//    searchBar.delegate =self;
//
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self verificaButoane];
}
//ecran pensiune



////////////////// ELEMENTE SI METODE LOCATIE  //////////////////
//// ADD GESTURE BOOL
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//// Userul a miscat harta
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //ComNSLog(@" MAP drag ended");
        if( mapView.userLocationVisible) {
            Localizeazama.selected =NO;
            //            [self opresteTrackingLocatieUser]; // ||core j
        } else {
            Localizeazama.selected =YES;
        }
    }
}

/////// icons pentru map points



//-(void)disclosureTapped {
//    EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
//    [self.navigationController presentModalViewController:ecranPensiune animated:YES ];
//}




/////// verifica permisiuni localizare user
- (void) checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:@"Pentru a putea afisa pensiuni din jurul tau, avem nevoie de locatia ta.\nIncearca din nou dupa ce modifici setarile telefonului."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
/////// second step la verificare permisiuni
-(void) checkApplicationHasLocationServicesPermission {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:@"Pentru a putea afisa pensiuni din jurul tau, avem nevoie de locatia ta.\nIncearca din nou dupa ce modifici setarile telefonului."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
/////// calculeaza map boounds
//First we need to calculate the corners of the map so we get the points
-(NSString *) MARGINIMAP{
    NSString *result = nil;
    CGPoint nePoint = CGPointMake( mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord;
    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord;
    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    //ComNSLog(@"THIS ONE %f THIS SECOND%f", neCoord.latitude, swCoord.longitude);
    NSString *MAPNE= [NSString stringWithFormat:@"%f", neCoord.latitude ];
    NSString *MAPSW = [NSString stringWithFormat:@"%f",swCoord.longitude];
    result =[NSString stringWithFormat:@"%@,%@", MAPNE, MAPSW];
    // result =[NSString stringWithFormat:@"44.4409904,26.15135"];
    //ComNSLog(@"merge ne,sw ? %@", result);
    return result;
}

/////// identifica locatia curenta
- (NSString *)deviceLocation {
    //for test
    //    return [NSString stringWithFormat:@"latitude: %f longitude: %f", 44.4409904, 26.15135];
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}
/////// SETEAZA LOCATIE IN CENTRUL ROMANIEI DACA USERUL NU A MAI FOST IN APLICATIE
-(void) goLocationCENTRU
{
    mapView.showsUserLocation=YES;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 45.48216;
    newRegion.center.longitude = 24.59176;
    newRegion.span.latitudeDelta = 0.6;
    newRegion.span.longitudeDelta = 0.6;
    newRegion = [mapView regionThatFits:newRegion];
    [mapView setRegion:newRegion animated:TRUE];
}
/////// ARATA LOCATIE USER

-(void) arataLocatieUser {
    if (![CLLocationManager locationServicesEnabled]) {
        [self checkLocationServicesTurnedOn];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self checkApplicationHasLocationServicesPermission];
    } else {
        mapView.showsUserLocation=YES;
        //        MKCoordinateRegion newRegion;
        //        //ComNSLog(@"%@", [self deviceLocation]);
        //        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        //
        ////        newRegion.center.latitude = locationManager.location.coordinate.latitude;
        ////        newRegion.center.longitude = locationManager.location.coordinate.longitude;
        ////        newRegion.span.latitudeDelta = 1;
        ////        newRegion.span.longitudeDelta = 1;
        ////        CLLocationCoordinate2D centerCoord = {newRegion.center.latitude , newRegion.center.longitude};
        ////        [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_14 animated:YES];
        
        //this is a fix
        MKCoordinateRegion region;
        region.center = locationManager.location.coordinate;
        region.span = MKCoordinateSpanMake(1.0, 1.0); //Zoom distance
        region = [self.mapView regionThatFits:region];
        CLLocationCoordinate2D centerCoord = {region.center.latitude , region.center.longitude};
        [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_14 animated:YES];
        
        
        
        //    newRegion = [mapView regionThatFits:newRegion];
        //    [mapView setRegion:newRegion animated:TRUE];
    }
}
-(void)opresteTrackingLocatieUser {
    MKCoordinateRegion newRegion;
    mapView.showsUserLocation=YES;
    //ComNSLog(@"%@", [self deviceLocation]);
    //    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    newRegion.center.latitude = locationManager.location.coordinate.latitude;
    newRegion.center.longitude = locationManager.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 1;
    newRegion.span.longitudeDelta = 1;
    CLLocationCoordinate2D centerCoord = {newRegion.center.latitude , newRegion.center.longitude};
    [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_7 animated:YES];
}
/////// BUTON LOCALIZARE USER
-(IBAction)ShowLocalizare:(id)sender {
    //    Localizeazama.selected = !Localizeazama.selected;
    if( mapView.userLocationVisible) {
        Localizeazama.selected =YES;
    } else {
        Localizeazama.selected =NO;
        [self arataLocatieUser];
        
        //        Localizeazama.selected =NO;
        //        [self opresteTrackingLocatieUser]; ||core J
        
    }
}
////////////////// ELEMENTE SI METODE CAUTARE  //////////////////
-(IBAction)ShowLupa:(id)sender {
    backbutton.hidden =YES;
    self.ruteButton.hidden =YES;
    //self.modificaRuta.hidden =NO;
    //       self.butonIstoric.hidden=NO;
    //ComNSLog(@"pres");
    
    //    Lupa.selected = !Lupa.selected;
    //    if (Lupa.selected) {
    //        [self.view addGestureRecognizer:ascundeLupa];
    //buton curata text si inchide search
    UIButton *curataInchide = [UIButton buttonWithType:UIButtonTypeCustom];
    [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateNormal];
    [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateSelected];
    
    [curataInchide addTarget:self
                      action:@selector(verificaSearch)
            forControlEvents:UIControlEventTouchUpInside];
    
    curataInchide.frame = CGRectMake(230, 6, 15, 15);
    searchBar.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [searchBar setRightView:curataInchide];
    //        [searchBar addSubview:curataInchide];
    //         [searchBar bringSubviewToFront:curataInchide];
    searchBar.hidden=NO;
    ButonMareAscuns2.hidden=NO;
    [self textFieldDidChange1:searchBar];
    table.hidden=NO;
    searchBar.placeholder = @"Punct de plecare";
    searchBar.hidden=NO;
    table.hidden=NO;
    
    toateRezultatele = [[NSMutableArray alloc]init];
    searchResults= toateRezultatele;
    CGRect frame = self.table.frame;
    frame.size.height = [searchResults count] * 50;
    [self.table setFrame:frame];
    [self.table reloadData];
    [self.table setNeedsDisplay];
    //    self.modificaRuta.hidden =YES;
    self.butonIstoric.hidden=NO;
    //    }   else {
    //        [self hideLupa];
    //   }
}
-(IBAction)AscundeSearch:(id)sender {
    //ComNSLog(@"ascunde search");
    //    [self.view sendSubviewToBack:ButonMareAscuns];
    [self hideLupa];
}
-(void)hideLupa{
    Lupa.selected= NO;
    searchBar.hidden=YES;
    [searchBar resignFirstResponder];
//    searchBar.placeholder=searchBarString;
    isFiltered=false;
    [self textFieldDidChange1:searchBar];
    [searchBar resignFirstResponder];
    ButonMareAscuns2.hidden=YES;
    searchResults = toateRezultatele;
    table.hidden=YES;
    [self.table setNeedsDisplay];
    [self.table reloadData];
    [self verificaButoane];
    
    //    [self.view removeGestureRecognizer:ascundeLupa];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //ComNSLog(@"begin editing---%@",textField.text);
    //if([textField.text isEqualToString:@""]){
    textField.text = @"";
    textField.placeholder = searchBar.placeholder;
    //}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //ComNSLog(@"end editing---%@",textField.text);
    if([textField.text isEqualToString:@"" ]){
        textField.placeholder = searchBar.placeholder;
    }
    
}



-(void)curataText{
    [searchBar becomeFirstResponder];
    searchBar.text = @"";
//    [self textFieldDidChange1:searchBar];
}
-(void)textFieldDidChange1 :(UITextField *)textfield
{
    //    cateSearch =searchBar.text.length;
//    [searchBar becomeFirstResponder];
    //    if([searchBar isFirstResponder]) {
    if([textfield.text isEqualToString:searchBarString]){
        [self curataText];
    }
    
    //}
    //  if(searchBar.text.length == 0) {
    //       searchBar.text =searchBarString;
    //    } else
    
    //ComNSLog(@"searchBar.text.length %i",searchBar.text.length);
    if(searchBar.text.length <3)
        
        //    if(searchBar.text.length ==0)
    {
        [searchBar becomeFirstResponder];
        //ComNSLog(@"ZZZZ");
        toateRezultatele =[[NSMutableArray alloc]init];
        isFiltered = false;
        searchResults=toateRezultatele;
        [self.table reloadData];
        [self.table setNeedsDisplay];
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * searchResults.count)];
        if(searchResults.count <3) {
            [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * searchResults.count)];
            
        } else {
            [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * 3)];
        }
        
        
        [self.table reloadData];
        [self.table setNeedsDisplay];
        //        [self searchBartextlengthJ];
    }
    else
    {
        
        [self searchBartextlengthJ];
        
    }
}
-(void)searchBartextlengthJ {
    [searchBar becomeFirstResponder];
    //ComNSLog(@"JJJ");
    ////JJJJ   [self PROCESEAZA_SUGESTII:searchBar.text];
    [self PROCESEAZA_SUGESTII_GOOGLE: searchBar.text];
    isFiltered = true;
    [self.table reloadData];
    [self.table setNeedsDisplay];
    
    //   NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"nume", searchText];//keySelected is NSString itself
    //           NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"nume", searchText];//keySelected is NSString itself
    //       searchResults = [NSArray arrayWithArray:[toateRezultatele filteredArrayUsingPredicate:predicateString]];
    //       searchResults = toateRezultatele;
    searchResults=toateRezultatele;
    if(searchResults.count >3) {
        searchResults = toateRezultatele;
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * 3)];
        [self.table setNeedsDisplay];}
    else {
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * searchResults.count)];
        [self.table setNeedsDisplay];}
    //ComNSLog(@"filt:: %@", searchResults);
    
}



//// TABEL CAUTARE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   //daca se face cautare  -> isFiltered
    if(searchResults && isFiltered) { return [searchResults count]; }
    else if  (toateRezultatele.count > 0 )  {return toateRezultatele.count;
    }
    else CLS_LOG(@"No data source ");
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"GenericCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenericCell"];
    //    NSUInteger row=indexPath.row;
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    UILabel *lblMainLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 14, 125, 25)];
    lblMainLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:11.0f];
    lblMainLabel.backgroundColor = [UIColor clearColor];
    lblMainLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1];
    lblMainLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [lblMainLabel setTextAlignment:NSTextAlignmentRight];
    //pt pensiune
    
    UILabel *textprincipal = [[UILabel alloc]initWithFrame:CGRectMake(10,2, tableView.frame.size.width -20, 48)];
    textprincipal.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    textprincipal.backgroundColor = [UIColor clearColor];
    textprincipal.textColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1];
    textprincipal.numberOfLines =0;
    textprincipal.lineBreakMode = NSLineBreakByWordWrapping;
    textprincipal.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [textprincipal setTextAlignment:NSTextAlignmentLeft];
    
    
    UILabel *lblMainLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 14, 125, 25)];
    lblMainLabel2.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
    lblMainLabel2.backgroundColor = [UIColor clearColor];
    lblMainLabel2.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    lblMainLabel2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [lblMainLabel2 setTextAlignment:NSTextAlignmentRight];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.textLabel.backgroundColor =[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1] ;
    
    if(isFiltered) {
        NSDictionary *afisareToate= [searchResults objectAtIndex: indexPath.row];
        //
        //        description = "Ploie\U0219ti Sud, Ploie\U0219ti, Jude\U021bul Prahova, Rom\U00e2nia";
        //        reference = "ClRMAAAAWd3ppclMcA45uFpzyD0S_M6JNkyyEj-HlB5QMupaQhxjjPB4RbBmQHB-6Vg7xImq19ne-zBLgOBjS87Vs3gtuGq8B2edJmejN3ZjxOGhe2ISED2b-wZL_1Gx6Kex5C8tEJ4aFFFmHYmPqj9UHe88OnerlVGEUF_g";
        NSString *tip = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"] ];
        //        cell.textLabel.text = tip;
        
        textprincipal.text = tip;
        [cell addSubview:textprincipal];
    }
    else   {
        NSDictionary *afisareToate= [toateRezultatele objectAtIndex: indexPath.row];
        NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"] ];
        //        cell.textLabel.text = titlurow;
        textprincipal.text = titlurow;
        [cell addSubview:textprincipal];
        //ComNSLog(@"row tabel full %@",titlurow );
        
    }
    UIView * separatorView;
    for(UIView * mView in cell.contentView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,50 - 0.5 , cell.frame.size.width, 0.5)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorView setTag:666];
    
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [cell.contentView addSubview:separatorView];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long ROWSelectat =indexPath.row;
    if(isFiltered) {
        NSDictionary *afisareToate= [searchResults objectAtIndex: ROWSelectat];
        self.stringSursaRuta = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"] ];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.startLocatie = self.stringSursaRuta;
        
        NSString *reference = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"] ];
        //ComNSLog(@"ce avem si unde il trimitem%@",reference );
        
        [ self PROCESEAZA_REFERINTA_GOOGLE:reference :self.pensiuneaSursa];
        //salveaza locatia in istoric NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *descriere =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"]];
        NSString *referintaUnica =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"]];
        NSMutableDictionary *PREDICTIE = [NSMutableDictionary dictionary];
        [PREDICTIE setObject:descriere forKey:@"description"];
        [PREDICTIE setObject:referintaUnica forKey:@"reference"];
        NSMutableArray *copieIstoric = [NSMutableArray arrayWithArray: [defaults objectForKey:@"IstoricLocatii.Cazare.ro"]];
        if(!copieIstoric) {
            //ComNSLog(@"Nu avem istoric");
            NSMutableArray *copieIstoric = [[NSMutableArray alloc]init];
            [copieIstoric addObject:PREDICTIE];
            [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            
            //ComNSLog(@"Avem istoric deja");
             if ([copieIstoric containsObject:PREDICTIE])
            { // do nothing locatia deja exista
                //ComNSLog(@"do nothing locatia deja exista");
            }
             else{
                 if(copieIstoric.count>20 ) {
                     //ComNSLog(@"sterge primul element 2");
                     //sterge cel mai vechi element din lista adica index 0
                     [copieIstoric removeObjectAtIndex:0];
                 }
                 [copieIstoric addObject:PREDICTIE];
             }

            [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self hideLupa];
    }
    else {
        NSDictionary *afisareToate= [toateRezultatele objectAtIndex: ROWSelectat];
        self.stringSursaRuta = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"] ];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.startLocatie = self.stringSursaRuta;
        NSString *reference = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"] ];
        //ComNSLog(@"ce avem si unde il trimitem%@",reference );
        [self hideLupa];
        [ self PROCESEAZA_REFERINTA_GOOGLE:reference :self.pensiuneaSursa];
        //salveaza locatia in istoric NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *descriere =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"]];
        NSString *referintaUnica =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"]];
        NSMutableDictionary *PREDICTIE = [NSMutableDictionary dictionary];
        [PREDICTIE setObject:descriere forKey:@"description"];
        [PREDICTIE setObject:referintaUnica forKey:@"reference"];
        
        NSMutableArray *copieIstoric = [[  NSMutableArray alloc]init];
         copieIstoric =[NSMutableArray arrayWithArray: [defaults objectForKey:@"IstoricLocatii.Cazare.ro"]];
        if (copieIstoric.count ==0) {
            //ComNSLog(@"Nu avem istoric");
            [copieIstoric addObject:PREDICTIE];
            [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            //ComNSLog(@"Avem istoric deja");
            copieIstoric =[NSMutableArray arrayWithArray: [defaults objectForKey:@"IstoricLocatii.Cazare.ro"]];
            if ([copieIstoric containsObject:PREDICTIE])
            { // do nothing locatia deja exista
                //ComNSLog(@"do nothing locatia deja exista");
            }
            else{
                if(copieIstoric.count>20 ) {
                    //ComNSLog(@"sterge primul element z");
                    //sterge cel mai vechi element din lista adica index 0
                    [copieIstoric removeObjectAtIndex:0];
                    
                }
                [copieIstoric addObject:PREDICTIE];
            }

            [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if(textField.tag ==60000) {
//        //ComNSLog(@"%s",__func__);
//    }
//}
- (void)didReceiveMemoryWarning
{
    //ComNSLog(@"%s",__func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//http://json.infopensiuni.ro/pensiuni/lista/localitate/?id=12
///preia sugestii

//http://json.infopensiuni.ro/all/lista/sugestii/?txt=palat
//http://json.infopensiuni.ro/pensiuni/lista/sugestii/?txt=sinaia
////////////////// Preia multe pensiuni :)  ////////////////// rezultat_REQ3

//



-(void) actualizeazaViewTabel {
    
    //ComNSLog(@"actualizare tabel ok:");
    searchResults = toateRezultatele;
    CGRect frame = self.table.frame;
    if(searchBar.text.length ==0) {
        searchResults = [[NSMutableArray alloc] init];
    }
    if(searchResults.count <3) {
        frame.size.height = [searchResults count] * 50;
    } else {
        frame.size.height = 3 * 50;
    }
    
    [self.table setFrame:frame];
    [self.table reloadData];
    [self.table setNeedsDisplay];
    //ComNSLog(@"actualizare tabel ok:---%@",NSStringFromCGRect(self.table.frame));
}



//    http://json.infopensiuni.ro/all/markers/bounds/?swlat=47.563554&gng=25.960264&nelat=47.563554&nelng=25.960264&stele=2,1,0,4,5&faraCategorii=54,59,71,47,57,56,52,51,67,53,60,44,41,48,49,66,50,40,62,61,45,43&pretMin=25&pretMax=690

////////////////// Preia harta PENSIUNI OBIECTIVE ALL ////////////////// rezultat_REQ2 -> default pensiuni




-(void)endRequestWithConnectionError:(NSString*)data{
    [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
    
}
-(void)redrawPins {
    [mapView setRegion:mapView.region animated:TRUE];
}
-(void) selfMAPREFRESH {
    [self arataLocatieUser];
    
    [self opresteTrackingLocatieUser];
    CLLocationCoordinate2D center = mapView.centerCoordinate;
    mapView.centerCoordinate = center;
    [mapView setNeedsDisplay];
}


///BUTOANE


-(IBAction)APASAok:(id)sender {
    //ComNSLog(@"%@%s", @"ok", __func__);
    [self.navigationController popToRootViewControllerAnimated:YES];
    // [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)decodeButton:(id)sender {
    //ComNSLog(@"aici");
    if (segmentedControl.selectedSegmentIndex == 0) {
        /*   self.HIDDENview.hidden =NO;
         //ComNSLog(@"%@%s", @"0", __func__);
         [Animations slideinFromLeft: HIDDENview animTime:1.0];
         //      [ HIDDENview setFrame:self.view.bounds];
         [ HIDDENview setFrame: CGRectMake(0,250, 320, 377)];
         AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         NSMutableArray *_SELECTIEStelePensiuni = appDelGlobal.SELECTIEStelePensiuni;
         //ComNSLog(@"SELECTIEStelePensiuni divers dupa alegeri %@",_SELECTIEStelePensiuni); // divers
         } else if(segmentedControl.selectedSegmentIndex == 1) {
         //ComNSLog(@"%@%s", @"1", __func__);
         [Animations slideinFromRight: HIDDENview animeTime:2.9];
         [ HIDDENview setFrame: CGRectMake(0,250, 320, 377)];
         self.HIDDENview.hidden =NO;*/
    }
}
/////alerte




-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tAlerta
                                                    message:mAlerta
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
- (IBAction)refreshTapped:(id)sender {
    // 1
}
//string is empty
-(BOOL)MyStringisEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == searchBar){
        //ComNSLog(@"google places:");
        [self queryGooglePlaces:searchBar.text];
    }
    return YES;
}
-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    //https://maps.googleapis.com/maps/api/place/textsearch/output?parameters
    //
    //    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@", googleType,   kGOOGLE_API_KEY];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&sensor=true&components=country:ro&query=%@",    kGOOGLE_BROWSER_KEY,googleType];
    
    //    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:
    //                            NSUTF8StringEncoding];
    //    encodedUrl=[encodedUrl stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    url=[url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //ComNSLog(@"google place urls %@", url);
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if(data ) {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        }
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    //ComNSLog(@"Google Data: %@", places);
    if(places.count !=0) {
        //Plot the data in the places array onto the map with the plotPostions method.
        
        [self plotPositions:places];
    } else {
        NSString *eroareGoogle =[ NSString stringWithFormat:@"Nu am gasit %@ pe harta.\nIncearca sa folosesti sugestiile sau navigheaza direct pe harta", searchBar.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:eroareGoogle
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    
}
- (void)plotPositions:(NSArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    //    for (id<MKAnnotation> annotation in mapView.annotations)
    //    {
    //        if ([annotation isKindOfClass:[MapPoint class]])
    //        {
    //            [mapView removeAnnotation:annotation];
    //        }
    //    }
    //
    //
    //Loop through the array of places returned from the Google API.
    //    for (int i=0; i<[data count]; i++)
    for (int i=0; i<1; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        //ComNSLog (@"locul google %@", place);
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        //not used to
        //        NSString *name=[place objectForKey:@"name"];
        //        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        //ComNSLog(@"placeCoord.latitude    placeCoord.longitude %f %f", placeCoord.latitude ,placeCoord.longitude);
        
        if (43.3707 < [[loc objectForKey:@"lat"] doubleValue] &&  [[loc objectForKey:@"lat"] doubleValue]<48.1506  && 20.1544 <[[loc objectForKey:@"lng"] doubleValue] && [[loc objectForKey:@"lng"] doubleValue] <29.4124) {
            //            Locatia e in Romania
            NSString *result = nil;
            /* if(self.stringPentruServer.length ==0){
             self.stringPentruServer = @"&stele=0,1,2,3,4,5";
             }*/
            result =[NSString stringWithFormat:@"%f,%f", placeCoord.latitude ,placeCoord.longitude];
            
            //ComNSLog(@"google rezult %@",result);
            /////////// fixeaza harta pe coordonate
            //si deseneaza direct :D
            //
            //            MKCoordinateRegion region;
            //
            //            CLLocationCoordinate2D  FizeazaHarta = CLLocationCoordinate2DMake([[loc objectForKey:@"lat"] floatValue],[[loc objectForKey:@"lng"]floatValue] );
            //            region.center = FizeazaHarta;
            //            MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
            //            region.span = span;
            //            //muta harta fara zoom ->are deja zoom 14
            //            [mapView setCenterCoordinate:FizeazaHarta zoomLevel:ZOOM_LEVEL_16 animated:YES];
            //            [mapView setRegion:region];
            //            [self hideLupa];
            NSDictionary *afisareToate= place;
            self.stringSursaRuta = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"name"] ];
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelGlobal.startLocatie = self.stringSursaRuta;
            
            NSString *reference = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"] ];
            //ComNSLog(@"ce avem si unde il trimitem%@",reference );
            [ self PROCESEAZA_REFERINTA_GOOGLE:reference :self.pensiuneaSursa];
            //salveaza locatia in istoric NSUserDefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *descriere =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"name"]];
            NSString *referintaUnica =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"]];
            NSMutableDictionary *PREDICTIE = [NSMutableDictionary dictionary];
            [PREDICTIE setObject:descriere forKey:@"description"];
            [PREDICTIE setObject:referintaUnica forKey:@"reference"];
            NSMutableArray *copieIstoric = copieIstoric =[NSMutableArray arrayWithArray: [defaults objectForKey:@"IstoricLocatii.Cazare.ro"]];
            if(!copieIstoric) {
                //ComNSLog(@"Nu avem istoric");
                NSMutableArray *copieIstoric = [[NSMutableArray alloc]init];
                [copieIstoric addObject:PREDICTIE];
                [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                
                //ComNSLog(@"Avem istoric deja");
              
                if ([copieIstoric containsObject:PREDICTIE])
                { // do nothing locatia deja exista
                    //ComNSLog(@"do nothing locatia deja exista");
                }
                else
                    if(copieIstoric.count >20 ) {
                          //ComNSLog(@"sterge primul element ");
                        //sterge cel mai vechi element din lista adica index 0
                        [copieIstoric removeObjectAtIndex:0];
                    }

                [copieIstoric addObject:PREDICTIE];
                [defaults setObject:copieIstoric forKey:@"IstoricLocatii.Cazare.ro"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [self hideLupa];
            
        }
        else {
            // nu este in Romania
            NSString *eroareGoogle =[ NSString stringWithFormat:@"Locatia nu se afla pe teritoriul Romaniei.\nIncearca sa folosesti sugestiile sau navigheaza direct pe harta"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                            message:eroareGoogle
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        //Create a new annotiation.
        // MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        //ROMANIA SPECIFIC LIMITS
        //       lat 43.3707 48.1506
        //       lng 20.1544 29.4124
        
        
        
        
        
        
        // [mapView addAnnotation:placeObject];
        
    }
}



-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(IBAction)backAction:(UIButton *)sender{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            //               AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //            appDelGlobal.startLocatie =nil;
            //            appDelGlobal.userLocatie=nil;
            //            appDelGlobal.stringPentruGoogle=nil;
            //            appDelGlobal.CMD_LOCATIE =@"";
            //            [self verificaButoane];
            //            CATransition *transition = [CATransition animation];
            //            transition.duration = 0.5;
            //            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //            transition.type = kCATransitionPush;
            //            transition.subtype = kCATransitionFromLeft;
            //            [self.view.window.layer addAnimation:transition forKey:nil];
            //            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self prezintaBack];
            break;
        }
        case ReachableViaWiFi:
        {
            //            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //            appDelGlobal.startLocatie =nil;
            //            appDelGlobal.userLocatie=nil;
            //            appDelGlobal.stringPentruGoogle=nil;
            //               [self verificaButoane];
            //
            //            CATransition *transition = [CATransition animation];
            //            transition.duration = 0.5;
            //            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //            transition.type = kCATransitionPush;
            //            transition.subtype = kCATransitionFromLeft;
            //            [self.view.window.layer addAnimation:transition forKey:nil];
            //            [self dismissViewControllerAnimated:YES completion:nil];
            [self prezintaBack];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }
    
}



-(void)prezintaBack{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.startLocatie =nil;
        appDelGlobal.userLocatie=nil;
        appDelGlobal.stringPentruGoogle=nil;
        appDelGlobal.CMD_LOCATIE =@"";
        [self verificaButoane];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelGlobal.startLocatie =nil;
            appDelGlobal.userLocatie=nil;
            appDelGlobal.stringPentruGoogle=nil;
            appDelGlobal.CMD_LOCATIE =@"";
            [self verificaButoane];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelGlobal.startLocatie =nil;
            appDelGlobal.userLocatie=nil;
            appDelGlobal.stringPentruGoogle=nil;
            appDelGlobal.CMD_LOCATIE =@"";
            [self verificaButoane];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
    
}


/// proceseaza google - aduce sugestii de places -> este folosit in tabelul de sugestii Google Places // la select in table va face request catre reference
/// si va intoarce lng lat dupa care deseneaza ruta pe harta
-(void)PROCESEAZA_SUGESTII_GOOGLE:(NSString *) cautare {
    NSString *baseUrl = [[NSString alloc ]init];
    baseUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?types=geocode&sensor=true&components=country:ro&language=ro&key=%@&input=%@",kGOOGLE_BROWSER_KEY,cautare];
    //ComNSLog(@"base autocomplete url google %@", baseUrl);
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        //        //ComNSLog(@"GOOGLE BIG RESULT %@", result);
        NSArray *predictions = [result objectForKey:@"predictions"];
        SugestiiGoogle = [[NSMutableArray alloc]init];
        for (NSDictionary *prediction in predictions) {
            NSString *descriere =[ NSString stringWithFormat:@"%@",[prediction objectForKey:@"description"]];
            NSString *referintaUnica =[ NSString stringWithFormat:@"%@",[prediction objectForKey:@"reference"]];
            NSMutableDictionary *PREDICTIE = [NSMutableDictionary dictionary];
            [PREDICTIE setObject:descriere forKey:@"description"];
            [PREDICTIE setObject:referintaUnica forKey:@"reference"];
            [SugestiiGoogle addObject:PREDICTIE];
        }
        //        //ComNSLog(@"SugestiiGoogle %@",SugestiiGoogle);
        //JMOD DOAR 3
        NSMutableArray  *toateRezultateleDoar3 =[[NSMutableArray alloc]init];
        for(int i=0;i<SugestiiGoogle.count;i++) {
            if (i<3){    id obj = [SugestiiGoogle objectAtIndex:i];
                [toateRezultateleDoar3 addObject:obj];
            }
        }
        toateRezultatele = toateRezultateleDoar3;
        // JMOD       toateRezultatele = SugestiiGoogle;
        searchResults = toateRezultatele;
        [self actualizeazaViewTabel];
    }];
    
}
//https://maps.googleapis.com/maps/api/place/details/json?reference=CkQ4AAAAsyk8ftukZ59XBpL_SzUNUIF9bZ2-VjdPIZkT8NBiTnSOTth5IuhvnnrRfrt_zFzLLrs2c8NdgPNG9BdUkprK1xIQN0PXXgmOf8hugvC-vS7dXxoUSL-wrKKtvibbBtIyqhsh729ow-o&sensor=true&key=AIzaSyB8M0XJYmlhlxj81r8WFkwWq_i78lwhWM0&country=ro&language=ro
-(void)PROCESEAZA_REFERINTA_GOOGLE :(NSString *) referinta :(NSMutableDictionary *)sursa {
    // just in case of hardcoded json   NSString *referinta = [[SugestiiGoogle lastObject]objectForKey:@"reference"];
    NSMutableDictionary *Laura = sursa; //reprezinta lat si lng pentru pensiunea curenta
    //    //ComNSLog(@"DATE SURSA PENSIUNE %@", Laura);
    NSString *urlComplet = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@&country=ro&language=ro", referinta,kGOOGLE_BROWSER_KEY];
    NSURL *url = [NSURL URLWithString:[urlComplet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //        //ComNSLog(@"GOOGLE REFERENCE RESULT %@", result);
        if(result) {
            //get lat, long of reference then ->
            //            geometry =         {
            //                location =             {
            //                    lat = "45.3310429";
            //                    lng = "25.5623504";
            //                };
            //name as you want // programming has fun :)
            NSDictionary *Ana = [[NSDictionary alloc]init]; // este rezultatul  de la request
            NSDictionary *Georgiana = [[NSDictionary alloc]init]; //este locatia de plecare (sau punct final, destinatie)
            Ana = [result objectForKey:@"result"];
            Georgiana = [[Ana objectForKey:@"geometry"] objectForKey:@"location"];
            //ComNSLog(@"NEW COORD %@", Georgiana);
            [self.mapView removeOverlays:self.mapView.overlays];
            for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
            {
                if ([overlayToRemove isKindOfClass:[MKPolylineView class]])
                {
                    [mapView removeOverlay:overlayToRemove];
                }
            }
            
            [self DianaDeseneazaRutaFrumos:Georgiana :Laura];
        }
        
        
        
    }];
    
}
-(void)DianaDeseneazaRutaFrumos :(NSDictionary *)rutaFinala  :(NSMutableDictionary *)sursa {
    
    
    //ComNSLog(@"diana deseneaza");
    [coordinateView setBackgroundColor:[UIColor whiteColor]];
    [coordinateView setAlpha:1.5f];
    [coordinateView.layer setBorderColor:UIColorFromRGB(0x94af39).CGColor];
    [coordinateView.layer setBorderWidth:1.5f];
    
    [coordinateLabel setTextColor:[UIColor grayColor]];
    [coordinateLabel setTextAlignment:NSTextAlignmentLeft];
    
    [sageataLeft setHidden:NO];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
    {
        if ([overlayToRemove isKindOfClass:[MKPolylineView class]])
        {
            [mapView removeOverlay:overlayToRemove];
        }
    }
    
    //!
    googlePlaceCoordinate.latitude = [[rutaFinala objectForKey:@"lat"] doubleValue];
    googlePlaceCoordinate.longitude = [[rutaFinala objectForKey:@"lng"] doubleValue];
    //        //ComNSLog(@"SugestiiGoogle %@",SugestiiGoogle);
    NSString *baseUrl = [[NSString alloc ]init];
    ////// here google maps
    //    if(locationManager.location.coordinate.latitude <1 && locationManager.location.coordinate.longitude <1 ) {
    //        baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=45.79817,24.970093&destination=%f,%f&sensor=true&country=ro&language=ro", self.pensionCoordinate.latitude, self.pensionCoordinate.longitude];
    //    }
    //  else {
    //ComNSLog(@"important cand vine din istoric %f %f",[[sursa objectForKey:@"lat"] floatValue],[[sursa objectForKey:@"lng"]floatValue]);
    baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&country=ro&language=ro", googlePlaceCoordinate.latitude,  googlePlaceCoordinate.longitude,[[sursa objectForKey:@"lat"] floatValue],[[sursa objectForKey:@"lng"] floatValue]];
    //    }
    //ComNSLog(@"baseurl google %@", baseUrl);
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *routes = [result objectForKey:@"routes"];
        //        //ComNSLog(@"rute %@", routes);
        if(routes.count !=0){
            NSDictionary *firstRoute = [routes objectAtIndex:0];
            NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
            //            legs =         (
            //                            {
            //                                distance =                 {
            //                                    text = "305 km";
            //                                    value = 304979;
            //                                };
            //                                duration =                 {
            //                                    text = "4 ore 31 min";
            //                                    value = 16262;
            //                                };
            NSDictionary *distance = [leg objectForKey:@"distance"];
            NSString *distanta =[distance objectForKey:@"text"];
            NSDictionary *duration = [leg objectForKey:@"duration"];
            NSString *durata =[duration objectForKey:@"text"];
            NSString *etichetaDeJos = [NSString stringWithFormat:@"%@, %@", distanta, durata];
            [coordinateLabel setText:etichetaDeJos];
            //            NSDictionary *end_location = [leg objectForKey:@"end_location"];
            //            double latitude = [[end_location objectForKey:@"lat"] doubleValue];
            //            double longitude = [[end_location objectForKey:@"lng"] doubleValue];
            //            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            //            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            //            point.coordinate = coordinate;
            //            point.title =  [leg objectForKey:@"end_address"];
            //            point.subtitle = @"I'm here!!!";
            //
            //            [self.mMapView addAnnotation:point];
            NSArray *steps = [leg objectForKey:@"steps"];
            int stepIndex = 0;
            CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
            stepCoordinates[stepIndex] = googlePlaceCoordinate;
            // array pentru indicatii
            self.indicationsArray =[[ NSMutableArray  alloc]init];
            NSMutableArray *indicatiifinale_tabel =  [[ NSMutableArray  alloc]init];
            for (NSDictionary *step in steps) {
                NSDictionary *start_location = [step objectForKey:@"start_location"];
                stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
                
                if ([steps count] == stepIndex){
                    NSDictionary *end_location = [step objectForKey:@"end_location"];
                    stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
                }
                //here my arr
                NSString *indicatie =[ NSString stringWithFormat:@"%@",[step objectForKey:@"html_instructions"]];
                NSArray *components = [indicatie componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
                //clean html this rude way
                NSMutableArray *componentsToKeep = [NSMutableArray array];
                for (int i = 0; i < [components count]; i = i + 2) {
                    [componentsToKeep addObject:[components objectAtIndex:i]];
                }
                NSString *indicatie_clean = [[  NSString alloc]init];
                indicatie_clean = [componentsToKeep componentsJoinedByString:@" "];
                [indicatiifinale_tabel addObject:indicatie_clean];
            }
            //        //ComNSLog(@"indicatiifinale_tabel %@",indicatiifinale_tabel);
            self.indicationsArray = indicatiifinale_tabel;
            //draw polyline
            
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
            //            //ComNSLog(@"polyline %@", polyLine);
            [self.mapView addOverlay:polyLine];
            [self.mapView setNeedsDisplay];
            //ComNSLog(@"gata");
            [self verificaButoane];
            CLLocationCoordinate2D upper = googlePlaceCoordinate;
            CLLocationCoordinate2D lower;
            lower.latitude =[[sursa objectForKey:@"lat"]doubleValue];
            lower.longitude =[[sursa objectForKey:@"lng"]doubleValue];
            // FIND LIMITS
            
            // FIND REGION
            MKCoordinateSpan locationSpan;
            if (upper.latitude > lower.latitude ) {
                locationSpan.latitudeDelta = upper.latitude - lower.latitude;
            }
            if (upper.latitude < lower.latitude ) {
                locationSpan.latitudeDelta =  lower.latitude -upper.latitude;
            }
            if(upper.longitude > lower.longitude) {
                locationSpan.longitudeDelta = upper.longitude - lower.longitude;
            }
            if(upper.longitude < lower.longitude) {
                locationSpan.longitudeDelta = lower.longitude - upper.longitude;
            }
            
            CLLocationCoordinate2D locationCenter;
            locationCenter.latitude = (upper.latitude + lower.latitude) / 2 ;
            locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
            MKCoordinateRegion region = MKCoordinateRegionMake(locationCenter, locationSpan);
            
            //   [mapView setCenterCoordinate:locationCenter zoomLevel:ZOOM_LEVEL_16 animated:YES];
            [mapView setRegion:region];
            mapView.showsUserLocation=YES;
            self.sageataLeft.hidden=NO;
        } else {
            [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
        }
        
        //        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((centerCoord.latitude + coordinate.latitude)/2, (centerCoord.longitude + coordinate.longitude)/2);
    }];
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //ComNSLog(@"s-a schimbat---%d",[localizeHUD isDescendantOfView:self.view]);
    if([localizeHUD isDescendantOfView:self.view]){
        [localizeHUD hide:YES];
        [localizeHUD setRemoveFromSuperViewOnHide:YES];
    }
}


-(IBAction)localizeAction:(UIButton *)sender{
    localizeHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    localizeHUD.labelText = @"Va rugam asteptati";
    //    if( mapView.userLocationVisible) {
    //
    //    } else {
    //        Localizeazama.selected =NO;
    ////        [self arataLocatieUser];
    //
    //        //        Localizeazama.selected =NO;
    //        //        [self opresteTrackingLocatieUser]; ||core J
    //
    //    }
    if(!showUser){
        Localizeazama.selected =YES;
        
        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        CGFloat minLatitude, minLongitude, maxLatitude, maxLongitude;
        if(pensionCoordinate.latitude < locationManager.location.coordinate.latitude){
            minLatitude = pensionCoordinate.latitude;
            maxLatitude = locationManager.location.coordinate.latitude;
        }
        else{
            minLatitude = locationManager.location.coordinate.latitude;
            maxLatitude = pensionCoordinate.latitude;
        }
        if(pensionCoordinate.longitude < locationManager.location.coordinate.longitude){
            minLongitude= pensionCoordinate.longitude;
            maxLongitude = locationManager.location.coordinate.longitude;
        }
        else{
            minLongitude= locationManager.location.coordinate.longitude;
            maxLongitude = pensionCoordinate.longitude;
        }
        
        
        MKCoordinateRegion region;
        
        
        region.center.latitude = (minLatitude + maxLatitude) / 2;
        region.center.longitude = (minLongitude + maxLongitude) / 2;
        
        region.span.latitudeDelta = (maxLatitude - minLatitude) * MAP_PADDING;
        
        region.span.latitudeDelta = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
        ? MINIMUM_VISIBLE_LATITUDE
        : region.span.latitudeDelta;
        
        region.span.longitudeDelta = (maxLongitude - minLongitude) * MAP_PADDING;
        
        MKCoordinateRegion scaledRegion = [mapView regionThatFits:region];
        [mapView setRegion:scaledRegion animated:YES];
        
        [coordinateLabel setText:[NSString stringWithFormat:@"%f, %f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude]];
        showUser = YES;
    }
    else{
        Localizeazama.selected =NO;
        [mapView setRegion:initialRegion animated:YES];
        showUser = NO;
    }
    
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}
-(IBAction)arataIndicatii:(id)sender {
    //ComNSLog(@"am apasat arata indicatii");
    if(self.indicationsArray.count !=0) {
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            EcranIndicatiiViewController * ecranindicatii = [[EcranIndicatiiViewController alloc] initWithNibName:@"EcranIndicatiiViewController" bundle:nil];
            //       a primitive way ecranindicatii.stringSursaRuta = self.stringSursaRuta;
            //a more elegant way
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelGlobal.startLocatie = self.stringSursaRuta;
            appDelGlobal.endLocatie = [myJson objectForKey:@"nume"];
            //ComNSLog(@"self.stringSursaRuta %@",self.stringSursaRuta);
            ecranindicatii.indicationsArray = self.indicationsArray;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranindicatii animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                EcranIndicatiiViewController * ecranindicatii = [[EcranIndicatiiViewController alloc] initWithNibName:@"EcranIndicatiiViewController" bundle:nil];
                //       a primitive way ecranindicatii.stringSursaRuta = self.stringSursaRuta;
                //a more elegant way
                AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelGlobal.startLocatie = self.stringSursaRuta;
                appDelGlobal.endLocatie = [myJson objectForKey:@"nume"];
                //ComNSLog(@"self.stringSursaRuta %@",self.stringSursaRuta);
                ecranindicatii.indicationsArray = self.indicationsArray;
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranindicatii animated:NO];
            }
            else{
                EcranIndicatiiViewController * ecranindicatii = [[EcranIndicatiiViewController alloc] initWithNibName:@"EcranIndicatiiViewController" bundle:nil];
                //       a primitive way ecranindicatii.stringSursaRuta = self.stringSursaRuta;
                //a more elegant way
                AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelGlobal.startLocatie = self.stringSursaRuta;
                appDelGlobal.endLocatie = [myJson objectForKey:@"nume"];
                //ComNSLog(@"self.stringSursaRuta %@",self.stringSursaRuta);
                ecranindicatii.indicationsArray = self.indicationsArray;
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranindicatii animated:NO];
            }
            
        }
        
        
    }
}
- (IBAction)APASARUTA:(id)sender {
    //ascunde butonul de back
    backbutton.hidden =YES;
    self.ruteButton.hidden =YES;
    //self.modificaRuta.hidden =NO;
    //       self.butonIstoric.hidden=NO;
    //ComNSLog(@"pres");
    UIButton *curataInchide = [UIButton buttonWithType:UIButtonTypeCustom];
    [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateNormal];
    [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateSelected];
    
    [curataInchide addTarget:self
                      action:@selector(verificaSearch)
            forControlEvents:UIControlEventTouchUpInside];
    
    curataInchide.frame = CGRectMake(230, 6, 15, 15);
    
    
    [self.view bringSubviewToFront:searchBar];
    searchBar.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [searchBar setRightView:curataInchide];
    //        [searchBar addSubview:curataInchide];
    //         [searchBar bringSubviewToFront:curataInchide];
    searchBar.placeholder = @"Punct de plecare";
    searchBar.hidden=NO;
    table.hidden=NO;
    
    toateRezultatele = [[NSMutableArray alloc]init];
    searchResults= toateRezultatele;
    CGRect frame = self.table.frame;
    frame.size.height = [searchResults count] * 50;
    [self.table setFrame:frame];
    [self.table reloadData];
    [self.table setNeedsDisplay];
    //    self.modificaRuta.hidden =YES;
    self.butonIstoric.hidden=NO;
    
}
- (IBAction)IstoricPressed:(id)sender {
    //ascunde butonul de back
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        [self hideLupa];
        EcranFavoriteViewController * ecrfav = [[EcranFavoriteViewController alloc] initWithNibName:@"EcranFavoriteViewController" bundle:nil];
        ecrfav.myJson = self.myJson;
        ecrfav.pensiuneaSursa = self.pensiuneaSursa;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self.navigationController pushViewController:ecrfav animated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            [self hideLupa];
            EcranFavoriteViewController * ecrfav = [[EcranFavoriteViewController alloc] initWithNibName:@"EcranFavoriteViewController" bundle:nil];
            ecrfav.myJson = self.myJson;
            ecrfav.pensiuneaSursa = self.pensiuneaSursa;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecrfav animated:NO];
        }
        else{
            [self hideLupa];
            EcranFavoriteViewController * ecrfav = [[EcranFavoriteViewController alloc] initWithNibName:@"EcranFavoriteViewController" bundle:nil];
            ecrfav.myJson = self.myJson;
            ecrfav.pensiuneaSursa = self.pensiuneaSursa;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecrfav animated:NO];
        }
        
    }
    
}
-(void) verificaButoane {
    
    NSMutableArray *toateLiniile = [[ NSMutableArray alloc]init];
    for (id<MKOverlay> overlayToRemove in self.mapView.overlays)
    {
        [toateLiniile addObject:overlayToRemove];
    }
    //ComNSLog(@"toateLiniile.count %i", toateLiniile.count);
    [self.mapView setNeedsDisplay];
    if( toateLiniile.count ==0 ){
        self.modificaRuta.hidden =YES;
        self.ruteButton.hidden =NO;
    } else {
        self.modificaRuta.hidden =NO;
        self.ruteButton.hidden =YES;
    }
    self.backbutton.hidden=NO;
    self.butonIstoric.hidden=YES;
    [self.coordinateLabel becomeFirstResponder];
    
}

@end


