//
//  StartViewController.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import "StartViewController.h"
#import "Animations.h"
#import "Annotation.h"
#import "MKMapView+ZoomLevel.h"
//#import "JPSThumbnailAnnotation.h" // custom images pt map annotations + J ideea red pin
#import "Ecran4Filtre.h"
#import "DataBaseMaster.h"
#import "AppDelegate.h"
#import "EcranPensiune.h"
#import "EcranObiectiveViewController.h"
#import "SMCalloutView.h"
#include "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "SMCalloutView.h"
#import "EcranListaObiectiveViewController.h"
#import "EcranListaPensiuniViewController.h"
#import "EcranFavoriteViewController.h"
#import "EcranIndicatiiViewController.h"
#import "MapPoint.h"
#import "MBProgressHUD.h"
#define ZOOM_LEVEL_14 14
#define ZOOM_LEVEL_7 7
#define MAXIMUM_ZOOM 20 //e maxim in mapkit
#define MERCATOR_RADIUS 85445659.44705395 //this is odd! :)
#define Default_pensiuni 1
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface StartViewController ()
@end
@implementation StartViewController
@synthesize Lupa,searchBar, isFiltered, table, butonMeniuSus,ButonMareAscuns,Localizeazama;
@synthesize TabelMeniu;
@synthesize IndicatorIncarcaDate,mapView,annoations,FullAnnotations,locationManager,toateRezultatele, toatefiltrele,butonPensiune,stringPentruServer;
@synthesize reverseGeocoder, fullId, cateSearch,tapGestureRecognizer,room_icons,myNorthEast, mySouthWest,TITLUECRAN;

//init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //ComNSLog(@"%s",__func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mySouthWest= CLLocationCoordinate2DMake(43.3707,20.1544);
    myNorthEast = CLLocationCoordinate2DMake(48.1506, 29.4124);
    __block id SELFINBLOCK = self;  ///// nu chema self in blocks regula folosita si mai jos
    self.room_icons = @{@"2pers":@"camera_dubla_m.png",@"2persm":@"camera_matrimoniala_m.png",@"1pers":@"camera_single_m.png",@"3pers":@"camera_tripla_m.png",@"1persg":@"garsoniera_m.png",@"4pers":@"apartament_m.png",@"all":@"toata_unitatea_m.png"};
    //// ADD GESTURE PENTRU A DETECTA DACA S-A MISCAT HARTA
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [mapView addGestureRecognizer:panRec];
    //initializeaza cateSearch -> just in case
    cateSearch =0;
    //// ASCUNDE BARA DE STARE
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    //// ELEMENTE GRAFICE
    TITLUECRAN.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    //// TEXT CAUTARE
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
    
    //   just in case you need  searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    //// BUTON LOCALIZARE
    UIImage* localizareOff = [UIImage imageNamed:@"track-icon-off_j.png"];
    [Localizeazama setBackgroundImage:localizareOff forState:UIControlStateNormal];
    UIImage* localizareOn = [UIImage imageNamed:@"track-icon-on_j.png"];
    [Localizeazama setBackgroundImage:localizareOn forState:UIControlStateSelected];
    Localizeazama.selected =NO;
    ////cancel all taps
    UITapGestureRecognizer *cancelAllTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMarker)];
    cancelAllTaps.cancelsTouchesInView = YES;
    cancelAllTaps.delaysTouchesBegan = YES;
    cancelAllTaps.delaysTouchesEnded = YES;
    //self.tapGestureRecognizer = tap;
    //// CUSTOM CALLOUT VIEW
    calloutView = [SMCalloutView new];
    calloutView.delegate = self;
    [calloutView addGestureRecognizer:cancelAllTaps];
    // adding a button in CalloutView
    UIButton *bottomDisclosure = [[UIButton alloc]init];
    [bottomDisclosure setBackgroundImage:[UIImage imageNamed:@"blue-arrow-icon.png"] forState:UIControlStateNormal];
    bottomDisclosure.frame = CGRectMake(14.0, 14.0, 23.5, 23.5);
    //blue-arrow-icon.png
    [bottomDisclosure addGestureRecognizer:cancelAllTaps];
    bottomDisclosure.tag = 5000;
    calloutView.rightAccessoryView = bottomDisclosure;
    //// MANAGER LOCATIE PRINCIPAL
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    //// fix inside map
    MKCoordinateRegion region;
    region.center = locationManager.location.coordinate;
    MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
    region.span = span;
    CLLocationCoordinate2D centerCoord = {45.47
        , 24.09 };
    //ComNSLog(@"center coordinate (ultima locatie):   %f,%f",centerCoord.latitude,centerCoord.longitude);
    [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_7 animated:YES];
    [mapView setRegion:region];
    /////////// PREIA FILTRE
    DataMasterProcessor *controller;
    controller = [[DataMasterProcessor alloc] init];
    [controller preiaFiltre_Ecran1];
    [mapView setDelegate:self];
    ///////// VERIFICA DACA EXISTA COMANDA
    //   [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
    // CMD_LISTA_OBIECTIVE CMD_ALL CMD_LISTA_PENSIUNI
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *VerificareFiltreGlobale =[defaults objectForKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
    //ComNSLog(@"defauls cmd:  %@", VerificareFiltreGlobale);
    BOOL egol  = [ self MyStringisEmpty :VerificareFiltreGlobale];
    if(egol) {
        self.stringPentruServer = @"&stele=0,1,2,3,4,5";
        appDelGlobal.CMD_STRING =CMD_LISTA_PENSIUNI;
        [SELFINBLOCK PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:CMD_LISTA_PENSIUNI];
    } else    if(!egol) {
        appDelGlobal.CMD_STRING =VerificareFiltreGlobale;
        [SELFINBLOCK PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:appDelGlobal.CMD_STRING];
    }
     /////////// ADUCE DATE INITIALE
    [SELFINBLOCK AduceDateInitiale];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//     self.mapView.userInteractionEnabled =YES;
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    __block id SELFINBLOCK = self;
    semaphore = NO; // putem afisa calloutview
    //ComNSLog(@"%s",__func__);
     //// BUTON LOCALIZARE
     if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
            [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - Localizeazama.frame.size.height - 25, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
    }
    else{
           [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.width - Localizeazama.frame.size.height - 25, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
     }
    //ComNSLog(@"deviceLocation %@", [self deviceLocation]);
    
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    appDelGlobal.stringPentruServer =[defaults objectForKey:@"StringFinalServer.Cazare.ro"];
    self.stringPentruServer = appDelGlobal.stringPentruServer;
    if(self.stringPentruServer.length ==0 && appDelGlobal.CMD_STRING.length ==0){
        self.stringPentruServer = @"&stele=0,1,2,3,4,5";
        [SELFINBLOCK PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:CMD_LISTA_PENSIUNI];
    } else {
        [SELFINBLOCK PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:appDelGlobal.CMD_STRING];
    }
    /////// inaltime tabel
    [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * toateRezultatele.count)];
    UITapGestureRecognizer *searchTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchButton)];
    UITapGestureRecognizer *filtretapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushFiltreButton)];
    [self.searchView addGestureRecognizer:searchTapGesture];
    [self.filtreView addGestureRecognizer:filtretapGesture];
    searchBar.delegate =self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    cateSearch =0;
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelGlobal.CMD_STRING isEqualToString:CMD_ALL]){
        searchBarString = @"Localitate, pensiune, obiectiv";
    }
    else{
        if ([appDelGlobal.CMD_STRING isEqualToString:CMD_LISTA_PENSIUNI]) {
            searchBarString = @"Localitate sau pensiune";
        }
        else{
            searchBarString = @"Localitate sau obiectiv";
        }
    }
}
//////////////////// ADUCE DATE INITIALE  ////////////////////
- (void) AduceDateInitiale {
    __block id SELFINBLOCK = self;
    //VERIFICA DACA USERUL E PRIMA DATA IN APLICATIE
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *primaIntrare = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.stareLogin"] ];
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.stareLogin"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.stareLogin"] class] == [NSNull class]){
        //ComNSLog(@"asa se face");
        NSString *stareLogin =@"primaIntrareInappunicL5YYNMwYRYzNDhNYOmF0ZMwtiDQN1khg2VDTzk3IGNCt0mTm";
        [defaults setObject:stareLogin forKey:@"CazareRomania.ro.stareLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //Centrul Romaniei 45°48'21, 6" N / 24°59'17, 6"
        [SELFINBLOCK goLocationCENTRU];
        //ComNSLog(@"prima intrare %@", primaIntrare);
        //ComNSLog(@"%s",__func__);
    }
    else {
        //citim ultima locatie daca exista ...
        CLLocationDegrees lat = [[NSUserDefaults standardUserDefaults] doubleForKey:kLocationLat];
        CLLocationDegrees lng = [[NSUserDefaults standardUserDefaults] doubleForKey:kLocationLng];
        if(lat && lng) {
            //            //daca datele salvate nu sunt prin Romania ? il ducem acolo ? inca nu /-> s-ar putea sa ceara asta
            //            if (43.000 < lat &&  lat<48.30
            //                && 20.1000 <lng && lng <29.44) {
            //                //            Locatia nu e in Romania asa ca-l focalizam  pe tara / e cazul in care device a dat 0 0
            //                [SELFINBLOCK KEEPMAPINSIDEROMANIA];
            //           }
            // a mai fost in aplicatie deci ii citim datele si pozitionam harta pe ultima locatie (centru)
            CLLocationCoordinate2D coord = {
                .latitude = lat,
                .longitude = lng
            };
            MKCoordinateRegion region;
            region.center = coord;
            MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
            region.span = span;
            CLLocationCoordinate2D centerCoord = {lat, lng };
            //ComNSLog(@"center coordinate (ultima locatie):   %f,%f",centerCoord.latitude,centerCoord.longitude);
            [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_7 animated:YES];
            [mapView setRegion:region];
             [self moveCenterByOffset:CGPointMake(4, 4) from:centerCoord];
            [mapView setNeedsDisplay];
         }else {
            // nu avem date salvate
            // updatam locatia si o scriem in USERDEFAULTS
            // Store the location
            [[NSUserDefaults standardUserDefaults] setDouble:locationManager.location.coordinate.latitude forKey:kLocationLat];
            [[NSUserDefaults standardUserDefaults] setDouble:locationManager.location.coordinate.longitude forKey:kLocationLng];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        }
        //ComNSLog(@"kLocationLat  %@ kLocationLng %@", [[NSUserDefaults standardUserDefaults] objectForKey:kLocationLat],[[NSUserDefaults standardUserDefaults] objectForKey: kLocationLng]);
    }
}
//////////////////// E FOLOSIT PER SESIUNE CAND VINE DIN ECRAN FILTRE SAU PE BAZA SETARILOR DE FILTRE ////////////////////
-(void)checkCmd :(NSString*)stringPentruServer{
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *cmd_local = appDelGlobal.CMD_STRING;
    self.stringPentruServer = appDelGlobal.stringPentruServer;
    if ([cmd_local isEqualToString:CMD_LISTA_PENSIUNI]) {
        //ComNSLog(@"WEBSERVICE %@", WEBSERVICE_MARKERS_PENSIUNI);
        [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer :cmd_local];
    }
    if ([cmd_local isEqualToString:CMD_LISTA_OBIECTIVE]) {
        //ComNSLog(@"WEBSERVICE %@", WEBSERVICE_MARKERS_OBIECTIVE);
        [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer :cmd_local];
    }
    if ([cmd_local isEqualToString:CMD_ALL]) {
        //ComNSLog(@"WEBSERVICE %@", WEBSERVICE_MARKERS_ALL);
        [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer :cmd_local];
    }
}

//////////////////// HARTA  ////////////////////
//////////////////// verifica permisiuni localizare user
- (void) checkLocationServicesTurnedOn {
    [localizeHUD setRemoveFromSuperViewOnHide:YES];
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:@"Pentru a putea afisa pensiuni din jurul tau, avem nevoie de locatia ta.\nIncearca din nou dupa ce modifici setarile telefonului."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
/////// second step la verificare permisiuni localizare user
-(void) checkApplicationHasLocationServicesPermission {
    
    [localizeHUD setRemoveFromSuperViewOnHide:YES];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:@"Pentru a putea afisa pensiuni din jurul tau, avem nevoie de locatia ta.\nIncearca din nou dupa ce modifici setarile telefonului."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
//////////////////// O METODA CARE SA MUTE HARTA CAND NU FACE REFRESH LA LOAD //J CORE
- (void)moveCenterByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    point.x += offset.x;
    point.y += offset.y;
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:center animated:YES];
    [self.mapView setNeedsDisplay];
}
//////////////////// ELEMENTE VIZUALE HARTA
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation *)annotation {
    if ([annotation isMemberOfClass:[MapAnnotation class]])
    {
        //if([pins count] > annotation.idAnn){
        return [pins objectAtIndex:annotation.idAnn];
        //}
    }
    return nil;
}
////////////////////
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // s-a facut tap pe butonul de disclusure ->   //ComNSLog(@"here j");
}
////////////////////
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(CustomPinAnnotationView *)view {
    // dismiss out callout if it's already shown but on a different parent view
    if (calloutView.window)
        [calloutView dismissCalloutAnimated:NO];
    if ([view isMemberOfClass:[CustomPinAnnotationView class]])
    {
        idAnn = view.idAnn;
    }
 	[self performSelector:@selector(popupMapCalloutView) withObject:nil afterDelay:1.0/3.0];
}
////////////////////// calloutView este custom view pentru annotation
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	// again, we'll introduce an artifical delay to feel more like MKMapView for this demonstration.
    [calloutView performSelector:@selector(dismissCalloutAnimated:) withObject:nil afterDelay:1.0/3.0];
}
////////////////////  HARTA ESTE ROTITA -> pentru a nu ajunge la -180 sau valori false pentru lat, lng
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    double rotation = newHeading.magneticHeading * 3.14159 / 180;
    CGPoint anchorPoint = CGPointMake(0, 25); // The anchor point for your pin
    [mapView setTransform:CGAffineTransformMakeRotation(-rotation)];
    [[mapView annotations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MKAnnotationView * view = [mapView viewForAnnotation:obj];
        [view setTransform:CGAffineTransformMakeRotation(rotation)];
        [view setCenterOffset:CGPointApplyAffineTransform(anchorPoint, CGAffineTransformMakeRotation(rotation))];
    }];
}
//////////////////// Userul a miscat harta prin pan sau tap
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //ComNSLog(@" MAP drag ended");
        if( mapView.userLocationVisible) {
            Localizeazama.selected =YES;
            //  nu folosim ->            [self opresteTrackingLocatieUser]; // ||core j
        } else {
            Localizeazama.selected =NO;
        }
        //se stocheaza locatia userului
        CLLocationCoordinate2D centre = [mapView centerCoordinate];
        //sunt 2 key in NSUserDefaults pentru lat, lng
        [[NSUserDefaults standardUserDefaults] setDouble:centre.latitude forKey:kLocationLat];
        [[NSUserDefaults standardUserDefaults] setDouble:centre.longitude forKey:kLocationLng];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //ComNSLog(@" MAP drag ended");
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //ComNSLog(@"app del cmd----%@", appDelGlobal.CMD_STRING);
        //daca nu exista nici un string de comanda, se vor incarca default pensiuni
        if(appDelGlobal.CMD_STRING == nil || [appDelGlobal.CMD_STRING class] == [NSNull class]){
            appDelGlobal.CMD_STRING = CMD_LISTA_PENSIUNI;
            //ComNSLog(@"gata");
        }
        [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:appDelGlobal.CMD_STRING];
    }
}
//////////////////// BUTON LOCALIZARE USER
-(IBAction)ShowLocalizare:(id)sender {
    Localizeazama.selected = !Localizeazama.selected;
    if(Localizeazama.selected) {
        //ComNSLog(@"e activ sau nu %hhd " , Localizeazama.selected);
        if( self.mapView.userLocationVisible) {
            [Localizeazama setSelected:YES]; //and do nothing here
        } else {
            [Localizeazama setSelected:YES];
            [self arataLocatieUser];
        }
    }
    else {
        if( self.mapView.userLocationVisible) {
            [Localizeazama setSelected:YES]; } else {
                //ComNSLog(@"e activ sau nu %hhd " , Localizeazama.selected);
                [Localizeazama setSelected:NO];
            }
    }
}
//////////////////// ARATA LOCATIE USER
-(void) arataLocatieUser {
    if (![CLLocationManager locationServicesEnabled]) {
        //        localizeHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        localizeHUD.labelText = @"Va rugam asteptati";
        [self checkLocationServicesTurnedOn];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self checkApplicationHasLocationServicesPermission];
    } else {
        mapView.showsUserLocation=YES;
        //ComNSLog(@"%@", [self deviceLocation]);
        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        MKCoordinateRegion region;
        region.center = locationManager.location.coordinate;
        region.span = MKCoordinateSpanMake(1.0, 1.0); //Zoom distance
        region = [self.mapView regionThatFits:region];
        CLLocationCoordinate2D centerCoord = {region.center.latitude , region.center.longitude};
        [mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL_14 animated:YES];
    }
}
//////////////////// opreste Tracking LocatieUser (just in case .is Core J)
-(void)opresteTrackingLocatieUser {
    MKCoordinateRegion newRegion;
    mapView.showsUserLocation=YES;
    //ComNSLog(@"%@", [self deviceLocation]);
    newRegion.center.latitude = locationManager.location.coordinate.latitude;
    newRegion.center.longitude = locationManager.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 1;
    newRegion.span.longitudeDelta = 1;
    CLLocationCoordinate2D centerCoord = {newRegion.center.latitude , newRegion.center.longitude};
    //ComNSLog(@"center coordinate (opreste tracking):   %f,%f",centerCoord.latitude,centerCoord.longitude);
    [mapView setCenterCoordinate:centerCoord  animated:YES];
}
//////////////////// Regiunea hartii s-a schimbat -> verifica ZOOM LEVEL
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if([localizeHUD isDescendantOfView:self.view]){
        [localizeHUD hide:YES];
        [localizeHUD setRemoveFromSuperViewOnHide:YES];
    }
    if( self.mapView.userLocationVisible) {
        Localizeazama.selected =YES;
    } else {
        Localizeazama.selected =NO;
    }
    CLLocationCoordinate2D centre = [self.mapView centerCoordinate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setDouble:centre.latitude forKey:kLocationLat];
    [[NSUserDefaults standardUserDefaults] setDouble:centre.longitude forKey:kLocationLng];
    [defaults synchronize];
    float zoomLevel =21 - round(log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width)));
    //ComNSLog(@"zoom float %f", zoomLevel);
    if (zoomLevel <6) {
        __weak id bself = self; // OK for iOS 5 only -> nu chema self in blocks regula folosita si mai jos
        [bself  KEEPMAPINSIDEROMANIA];
    }
}
//////////////////// Fix map inside Romania (vezi si exemplul lasat in subsol -> gotoAmerica )
-(void)KEEPMAPINSIDEROMANIA {
    //ComNSLog(@"KEEP IN COUNTRY");
    CLLocationCoordinate2D lowerLeftCoOrd = CLLocationCoordinate2DMake(43.3707, 20.1544);
    MKMapPoint lowerLeft = MKMapPointForCoordinate(lowerLeftCoOrd);
    CLLocationCoordinate2D upperRightCoOrd = CLLocationCoordinate2DMake(48.1506, 29.4124);
    MKMapPoint upperRight = MKMapPointForCoordinate(upperRightCoOrd);
    MKMapRect mapRect = MKMapRectMake(lowerLeft.x, upperRight.y, upperRight.x - lowerLeft.x, lowerLeft.y - upperRight.y);
    [self.mapView setVisibleMapRect:mapRect  animated:YES];
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *cmd_local = appDelGlobal.CMD_STRING;
    self.stringPentruServer = appDelGlobal.stringPentruServer;
    double delayInSeconds = 2.0;
    __block id SELFINBLOCK = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SELFINBLOCK PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer :cmd_local ];
    });
}
//////////////////// calculeaza map boounds
//////////////////// First we need to calculate the corners of the map so we get the points
-(NSString *) MARGINIMAP{
    NSString *result = nil;
    CGPoint nePoint = CGPointMake( mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    //ComNSLog(@"marginimap---%@",NSStringFromCGRect(mapView.bounds));
    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord;
    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord;
    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    //ComNSLog(@"THIS ONE %f THIS SECOND%f", neCoord.latitude, swCoord.longitude);
    NSString *MAPNE= [NSString stringWithFormat:@"%f,%f", neCoord.latitude,neCoord.longitude ];
    NSString *MAPSW = [NSString stringWithFormat:@"%f,%f",swCoord.latitude,swCoord.longitude];
    result =[NSString stringWithFormat:@"%@~%@", MAPNE, MAPSW];
    // result =[NSString stringWithFormat:@"44.4409904,26.15135"];
    //ComNSLog(@"merge ne,sw ? %@", result);
    return result;
}
//////////////////// identifica locatia curenta
- (NSString *)deviceLocation {
    //for test
    //    return [NSString stringWithFormat:@"latitude: %f longitude: %f", 44.4409904, 26.15135];
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}
//////////////////// SETEAZA LOCATIE IN CENTRUL ROMANIEI DACA USERUL NU A MAI FOST IN APLICATIE
-(void) goLocationCENTRU
{
    mapView.showsUserLocation=YES;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 45.47;
    newRegion.center.longitude = 24.09;
    newRegion.span.latitudeDelta = 0.6;
    newRegion.span.longitudeDelta = 0.6;
    newRegion = [mapView regionThatFits:newRegion];
    [mapView setRegion:newRegion animated:TRUE];
}
////////////////////
-(void)redrawPins {
    [mapView setRegion:mapView.region animated:TRUE];
}
////////////////////
-(void) selfMAPREFRESH {
    [self arataLocatieUser];
    [self opresteTrackingLocatieUser];
    CLLocationCoordinate2D center = mapView.centerCoordinate;
    mapView.centerCoordinate = center;
    [mapView setNeedsDisplay];
}


//////////////////// calloutView este custom view pentru annotation COMPONENTA CUSTOM ->am modificat SMCallOutView
- (void)popupMapCalloutView {
    if(!semaphore){
        UITapGestureRecognizer *cancelAllTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMarker)];
        cancelAllTaps.cancelsTouchesInView = YES;
        // Change this for creating your Callout View
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 34)];
        NSDictionary *itemX = [self.FullAnnotations objectAtIndex:idAnn]; //reprezinta annotation id pentru pin-ul selectat
        //ComNSLog(@"item selectat %@", itemX);
        UIImageView * imgView = [[UIImageView alloc] init];
        [imgView setFrame:CGRectMake(customView.frame.origin.x,customView.frame.origin.y, 33, 33)];
        NSString *poza =[NSString stringWithFormat:@"%@",[itemX objectForKey:@"foto"]];
        [self downloadImageWithURL:[NSURL URLWithString:poza] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                if(image) {
                    [imgView setImage:image];
                }
            }
            else {
                [imgView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imagine-pensiune" ofType:@"jpg"]]];
            }
        }];
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled =YES;
        [imgView  addGestureRecognizer:cancelAllTaps];
        [customView addSubview:imgView];
        NSString *tipRaspuns = [itemX objectForKey:@"tipRaspuns"];
        NSString *titlu = [[NSString alloc] init];
        NSString *subtitlu = [[NSString alloc] init];
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
        UILabel * subtitleLabel;
        //se verifica tipul
        //////////////////// grup obiective
        if([ tipRaspuns isEqualToString:@"grup_obiective"]) {
            titlu = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"ids"] ];
            NSArray*cate = [titlu componentsSeparatedByString:@","];
            if(cate.count ==1) {
                titlu =[NSString stringWithFormat:@"%d obiectiv", cate.count];
            } else if(cate.count >1 ){
                titlu =[NSString stringWithFormat:@"%d obiective", cate.count];
            }
            subtitlu =@"";
            [title setFrame:CGRectMake(40.0, 6.0, 210.0, 19.0)];
            //////////////////// obiectiv
        } else   if([ tipRaspuns isEqualToString:@"obiectiv"]) {
            titlu = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"nume"] ];
            subtitlu =@"";
            [title setFrame:CGRectMake(40.0, 6.0, 210.0, 19.0)];
            //////////////////// grup pensiuni
        } else   if([ tipRaspuns isEqualToString:@"grup_pensiuni"]) {
            titlu = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"ids"] ];
            NSArray*cate = [titlu componentsSeparatedByString:@","];
            if(cate.count ==1) {
                titlu =[NSString stringWithFormat:@"%d pensiune", cate.count];
            } else if(cate.count >1 ){
                titlu =[NSString stringWithFormat:@"%d pensiuni", cate.count];
            }
            subtitlu =@"";
            [title setFrame:CGRectMake(40.0, 6.0, 210.0, 19.0)];
            //////////////////// pensiune
        }  else   if([ tipRaspuns isEqualToString:@"pensiune"]) {
            [title setFrame:CGRectMake(40.0, 1.0, 220.0, 19.0)];
            NSString *tip =[NSString stringWithFormat:@"%@",[itemX objectForKey:@"tip"] ];
            NSString *nume = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"nume"]];
            titlu = [NSString stringWithFormat:@"%@ %@", tip, nume];
            NSDictionary *pretTot =[itemX objectForKey:@"tarif"];
            NSString *moneda=[NSString stringWithFormat:@"%@",[pretTot objectForKey:@"moneda"]];
            NSString *suma=[NSString stringWithFormat:@"%@",[pretTot objectForKey:@"suma"]];
            NSString *tipzinoapte=[NSString stringWithFormat:@"%@",[pretTot objectForKey:@"tip"]];
            subtitlu = [NSString stringWithFormat:@"%@ %@ / %@", suma, moneda, tipzinoapte];
            // imaginea pentru pin
            UIImageView * subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(customView.frame.origin.x +42, customView.frame.origin.y+19, 20, 10)];
            [subtitleImageView setContentMode:UIViewContentModeScaleAspectFit];
            UIImage *iconImage =[UIImage imageNamed:room_icons[pretTot[@"icon"]]];
            //ComNSLog(@"icon image size---%@", NSStringFromCGSize(iconImage.size));
            //ComNSLog(@"icon image size---%@", NSStringFromCGSize(subtitleImageView.image.size));
            [subtitleImageView setImage:iconImage];
            subtitleImageView.userInteractionEnabled =YES;
            [subtitleImageView  addGestureRecognizer:cancelAllTaps];
            [customView addSubview:subtitleImageView];
            // subtitlu text
            subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleImageView.frame.origin.x + subtitleImageView.frame.size.width + 2, customView.frame.origin.y +19, 180, 14)];
            subtitleLabel.font =[UIFont fontWithName:@"OpenSans" size:11.0f];
            [subtitleLabel setBackgroundColor:[UIColor clearColor]];
            [subtitleLabel setTextColor:[UIColor colorWithRed:175/255.0 green:207/255.0 blue:69/255.0 alpha:1.0]];
            [subtitleLabel setText:subtitlu];
            CGSize mSize = [subtitleLabel sizeThatFits:CGSizeMake(160, 13)];
            CGRect fr = subtitleLabel.frame;
            if(mSize.height <= 13){
                fr.size.height = 13;//mSize.height;
                fr.size.width = mSize.width;
            }
            else{
                fr.size.height = 13;
            }
            [subtitleLabel setFrame:fr];
            subtitleLabel.userInteractionEnabled =YES;
            [subtitleLabel  addGestureRecognizer:cancelAllTaps];
            [customView addSubview:subtitleLabel];
        }
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 0;
        title.backgroundColor = [UIColor clearColor];
        title.text = titlu;
        [customView addSubview:title];
        title.userInteractionEnabled =YES;
        [title  addGestureRecognizer:cancelAllTaps];
        CGSize mSize = [title sizeThatFits:CGSizeMake(210, 28)];
        //ComNSLog(@"title size:  %@", NSStringFromCGSize([title sizeThatFits:CGSizeMake(210, 28)]));
        CGRect fr = title.frame;
        if(mSize.height <= 28){
            fr.size.height = 19;//mSize.height;
            fr.size.width = mSize.width;
        }
        else{
            fr.size.height = 19;
        }
        [title setFrame:fr];
        CGRect newCustomViewFrame = customView.frame;
        int firstOp = title.frame.size.width + title.frame.origin.x + 10;
        int secondOp = subtitleLabel.frame.size.width + subtitleLabel.frame.origin.x + 10;
        if(firstOp > secondOp){
            newCustomViewFrame.size.width = firstOp;
            [customView setFrame:newCustomViewFrame];
        }
        else{
            newCustomViewFrame.size.width = secondOp;
            [customView setFrame:newCustomViewFrame];
        }
        //ComNSLog(@"title frame---%@", title);
        // if you provide a custom view for the callout content, the title and subtitle will not be displayed
        calloutView.contentView = customView;
        
        calloutView.totcontentul.frame  = customView.frame;
        [calloutView.totcontentul  addGestureRecognizer:cancelAllTaps];
        [customView addSubview:calloutView.totcontentul];
        [customView bringSubviewToFront:calloutView.totcontentul];
        CustomPinAnnotationView *bottomPin = [pins objectAtIndex:idAnn];
        bottomPin.calloutView = calloutView;
        [calloutView presentCalloutFromRect:bottomPin.bounds
                                     inView:bottomPin
                          constrainedToView:mapView
                   permittedArrowDirections:SMCalloutArrowDirectionAny
                                   animated:YES ];
        //    [self performSelector:@selector(goToMarker) withObject:nil afterDelay:5];
        //ComNSLog(@"content view frame---%@", NSStringFromCGRect(calloutView.contentView.frame));
        [calloutView addGestureRecognizer:cancelAllTaps];
        //     nu permitem userului sa faca tap prin view pe alte obiective din spate :)
        //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        //    tap.cancelsTouchesInView = YES;
        //   tap.delaysTouchesBegan = YES;
        //   tap.delaysTouchesEnded = YES;
        //self.tapGestureRecognizer = tap;
        //     [calloutView addGestureRecognizer:tap];
        //ComNSLog(@"here j class of  calloutView %@", [calloutView class]);
    }
   
}
//////////////////// calloutView este repozitionat pe harta
- (NSTimeInterval)calloutView:(SMCalloutView *)theCalloutView delayForRepositionWithSize:(CGSize)offset {
    // Uncomment this to cancel the popup
    // [calloutView dismissCalloutAnimated:NO];
	// if annotation view is coming from MKMapView, it's contained within a MKAnnotationContainerView instance
	// so we need to adjust the map position so that the callout will be completely visible when displayed
	if ([NSStringFromClass([calloutView.superview.superview class]) isEqualToString:@"MKAnnotationContainerView"]) {
		CGFloat pixelsPerDegreeLat = mapView.frame.size.height / mapView.region.span.latitudeDelta;
		CGFloat pixelsPerDegreeLon = mapView.frame.size.width / mapView.region.span.longitudeDelta;
		
		CLLocationDegrees latitudinalShift = offset.height / pixelsPerDegreeLat;
		CLLocationDegrees longitudinalShift = -(offset.width / pixelsPerDegreeLon);
		
		CGFloat lat = mapView.region.center.latitude + latitudinalShift;
		CGFloat lon = mapView.region.center.longitude + longitudinalShift;
		CLLocationCoordinate2D newCenterCoordinate = (CLLocationCoordinate2D){lat, lon};
		if (fabsf(newCenterCoordinate.latitude) <= 90 && fabsf(newCenterCoordinate.longitude <= 180)) {
            //ComNSLog(@"center coordinate (delay):   %f,%f",newCenterCoordinate.latitude,newCenterCoordinate.longitude);
			[mapView setCenterCoordinate:newCenterCoordinate animated:YES];
		}
	}
    return kSMCalloutViewRepositionDelayForUIScrollView;
}
//////////////////// userul a selectat annotation pin si executam comanda catre server in functie de select
- (void)goToMarker
{
   // self.mapView.userInteractionEnabled =NO;

        __block id SELFINBLOCK = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:hud];
        NSDictionary *itemX = [self.FullAnnotations objectAtIndex:idAnn];
        semaphore = YES; // se face o operatiune asa ca afisarea callout-ului este blocata
        //ComNSLog(@"item selectatx %@", itemX);
        NSString *tipRaspuns = [itemX objectForKey:@"tipRaspuns"];
        if([ tipRaspuns isEqualToString:@"grup_obiective"]) {
            NSArray *obiectiveIDS = [itemX objectForKey:@"ids"];
            NSString *obiectiveIDSString = [NSString stringWithFormat:@""];
            obiectiveIDSString = [obiectiveIDS componentsJoinedByString:@","];
            //ComNSLog(@"obiective ids---%@",obiectiveIDSString);
            [SELFINBLOCK VerificaAreNet:tipRaspuns :obiectiveIDSString];
        } else   if([ tipRaspuns isEqualToString:@"obiectiv"]) {
            NSString *obiectivID = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"id"]];
            [SELFINBLOCK VerificaAreNet:tipRaspuns :obiectivID];
        } else   if([ tipRaspuns isEqualToString:@"grup_pensiuni"]) {
            NSArray *pensiuniIDS = [itemX objectForKey:@"ids"];
            NSString *pensiuniIDSString = [NSString stringWithFormat:@""];
            pensiuniIDSString = [pensiuniIDS componentsJoinedByString:@","];
            //ComNSLog(@"obiective ids---%@",pensiuniIDSString);
            [SELFINBLOCK VerificaAreNet:tipRaspuns :pensiuniIDSString];
        }  else   if([ tipRaspuns isEqualToString:@"pensiune"]) {
            NSString *pensiuneID = [NSString stringWithFormat:@"%@",[itemX objectForKey:@"id"]];
            [SELFINBLOCK VerificaAreNet:tipRaspuns :pensiuneID];
        }

    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        //// BUTON LOCALIZARE
        [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - Localizeazama.frame.size.height - 25, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 *searchResults.count)];
        [self.table setNeedsDisplay];
    }
    else{
        [Localizeazama setFrame:CGRectMake(Localizeazama.frame.origin.x, [[UIScreen mainScreen] bounds].size.width - Localizeazama.frame.size.height - 25, Localizeazama.frame.size.width,  Localizeazama.frame.size.height)];
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 *searchResults.count)];
        [self.table setNeedsDisplay];
    }
}

-(void)verificaSearch {
    //ComNSLog(@"curata");
    //[self   curataText];
    if ([searchBar.text isEqualToString:@""]) {
        [self hideLupa];
    } else {
        searchBar.text =@"";
        searchBar.placeholder = searchBarString;
        [self textFieldDidChange1:searchBar];
    }
}

//////////////// pregateste LISTA pensiuni
-(void) pregatestePensiuniIDS :(NSString*)pensiuniIDS {
    __block id SELFINBLOCK = self;
    if(pensiuniIDS) {

        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@", WEBSERVICE_LISTA_PENSIUNI ,pensiuniIDS];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url lista pensiuni %@", url);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
 
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_PENSIUNIIDS = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:nil];
            //ComNSLog(@"rezolva pensiuni:  %@", responseString);
//            if(REZOLVA_PENSIUNIIDS == nil || [REZOLVA_PENSIUNIIDS class] == [NSNull class]){
//
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            else{
//                if([REZOLVA_PENSIUNIIDS isKindOfClass:[NSDictionary class]]){
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [self.view addSubview:hud];
//                    [SELFINBLOCK rezolvaPensiuniIDS:REZOLVA_PENSIUNIIDS];
//                }
//                else{
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//
//            }
            
            if([self checkDictionary:REZOLVA_PENSIUNIIDS]){

                [SELFINBLOCK rezolvaPensiuniIDS:REZOLVA_PENSIUNIIDS];

            }
            else{
                semaphore = NO; // incarcare esuata, se poate afisa din nou callout
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
            
            
        }];
        [request setFailedBlock:^{
            semaphore = NO; // incarcare esuata, se poate afisa din nou callout
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
                       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [request startAsynchronous];
    }
    }
}
-(void) rezolvaPensiuniIDS:(NSDictionary *)REZOLVA_PENSIUNIIDS {
    __block id SELFINBLOCK = self;
    if(REZOLVA_PENSIUNIIDS) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            [SELFINBLOCK hideLupa];
            EcranListaPensiuniViewController *ecranlistaObiective = [[EcranListaPensiuniViewController alloc] initWithNibName:@"EcranListaPensiuniViewController" bundle:nil];
            ecranlistaObiective.myList =REZOLVA_PENSIUNIIDS[@"results"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranlistaObiective animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                [SELFINBLOCK hideLupa];
                EcranListaPensiuniViewController *ecranlistaObiective = [[EcranListaPensiuniViewController alloc] initWithNibName:@"EcranListaPensiuniViewController" bundle:nil];
                ecranlistaObiective.myList =REZOLVA_PENSIUNIIDS[@"results"];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranlistaObiective animated:NO];
            }
            else{
                [SELFINBLOCK hideLupa];
                EcranListaPensiuniViewController *ecranlistaObiective = [[EcranListaPensiuniViewController alloc] initWithNibName:@"EcranListaPensiuniViewController" bundle:nil];
                ecranlistaObiective.myList =REZOLVA_PENSIUNIIDS[@"results"];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranlistaObiective animated:NO];
            }
            
        }
        
    }
}


//////////////// pregateste LISTA obiective
-(void) pregatesteObiectiveIDS :(NSString*)obiectiveIDS {
    __block id SELFINBLOCK = self;
    if(obiectiveIDS) {

        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@", WEBSERVICE_LISTA_OBIECTIVE ,obiectiveIDS];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url lista obiective %@", url);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            //ComNSLog(@"response: %@",responseString);
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_OBIECTIVEIDS = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:kNilOptions
                                                                                   error:nil];
            
            if([self checkDictionary:REZOLVA_OBIECTIVEIDS]){
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                [self.view addSubview:hud];
                [SELFINBLOCK rezolvaObiectiveIDS:REZOLVA_OBIECTIVEIDS];
            }
            else{
                semaphore = NO; // incarcare esuata, se poate afisa din nou callout
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSError *error = [request error];
                //ComNSLog(@"Error: %@", error.localizedDescription);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            

        }];
        [request setFailedBlock:^{
            semaphore = NO; // incarcare esuata, se poate afisa din nou callout
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

            
        }];
        [request startAsynchronous];
    }
    }
}
-(void) rezolvaObiectiveIDS:(NSDictionary *)REZOLVA_OBIECTIVEIDS {
    __block id SELFINBLOCK = self;
    if(REZOLVA_OBIECTIVEIDS) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            [self hideLupa];
            EcranListaObiectiveViewController *ecranlistaObiective = [[EcranListaObiectiveViewController alloc] initWithNibName:@"EcranListaObiectiveViewController" bundle:nil];
            ecranlistaObiective.myJson = REZOLVA_OBIECTIVEIDS[@"results"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranlistaObiective animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                [self hideLupa];
                EcranListaObiectiveViewController *ecranlistaObiective = [[EcranListaObiectiveViewController alloc] initWithNibName:@"EcranListaObiectiveViewController" bundle:nil];
                ecranlistaObiective.myJson = REZOLVA_OBIECTIVEIDS[@"results"];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranlistaObiective animated:NO];
            }
            else{
                [SELFINBLOCK hideLupa];
                EcranListaObiectiveViewController *ecranlistaObiective = [[EcranListaObiectiveViewController alloc] initWithNibName:@"EcranListaObiectiveViewController" bundle:nil];
                ecranlistaObiective.myJson = REZOLVA_OBIECTIVEIDS[@"results"];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranlistaObiective animated:NO];
            }
            
        }
        
    }
}
//////////////// pregateste ecran obiectiv
-(void) pregatesteObiectiv :(NSString*)obiectivID {
    __block id SELFINBLOCK = self;
    if(obiectivID) {

        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@/", WEBSERVICE_OBIECTIV,obiectivID];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url obiectiv %@", url);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
//            NSString *path = [[responseString
//                               stringByReplacingOccurrencesOfString:@"\\'" withString:@"\\\""]
//                              stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_OBIECTIV = [NSJSONSerialization JSONObjectWithData:data
                                              
                                                                             options:kNilOptions
                                                                               error:nil];
            //ComNSLog(@"Response obor: %@", responseString);
//            //ComNSLog(@"response json: %@", path);
            
            if([self checkDictionary:REZOLVA_OBIECTIV]){
                [SELFINBLOCK rezolvaObiectiv:REZOLVA_OBIECTIV];
            }
            else{
                semaphore = NO; // incarcare esuata, se poate afisa din nou callout
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
        [request setFailedBlock:^{
            semaphore = NO; // incarcare esuata, se poate afisa din nou callout
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }];
        [request startAsynchronous];
    }
    }
}
-(void) rezolvaObiectiv:(NSDictionary *)REZOLVA_OBIECTIV {
    __block id SELFINBLOCK = self;
    if(REZOLVA_OBIECTIV) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            [self hideLupa];
            EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
            ecranObiectiv.myJson = REZOLVA_OBIECTIV;
            ecranObiectiv.backString = @"Harta";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranObiectiv animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                [SELFINBLOCK hideLupa];
                EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
                ecranObiectiv.myJson = REZOLVA_OBIECTIV;
                ecranObiectiv.backString = @"Harta";
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranObiectiv animated:NO];
            }
            else{
                [SELFINBLOCK hideLupa];
                EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
                ecranObiectiv.myJson = REZOLVA_OBIECTIV;
                ecranObiectiv.backString = @"Harta";
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranObiectiv animated:NO];
            }
            
        }
        
    }
}
//////////////// pregateste ecran pensiune
-(void) pregatestePensiune :(NSString*)pensiuneID {
    __block id SELFINBLOCK = self;
    if(pensiuneID) {

        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@/", WEBSERVICE_PENSIUNE,pensiuneID];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url pensiune %@", url);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_PENSIUNE = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:nil];
            if([self checkDictionary:REZOLVA_PENSIUNE]){

                //ComNSLog(@"Response: %@", responseString);
                [SELFINBLOCK rezolvaPensiune:REZOLVA_PENSIUNE];
            }
            else{
                semaphore = NO; // incarcare esuata, se poate afisa din nou callout
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            

        }];
        [request setFailedBlock:^{
            semaphore = NO; // incarcare esuata, se poate afisa din nou callout
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [request startAsynchronous];
    }
    }
}
-(void) rezolvaPensiune:(NSDictionary *)REZOLVA_PENSIUNE {
    __block id SELFINBLOCK = self;
    if(REZOLVA_PENSIUNE) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            [self hideLupa];
            EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
            ecranPensiune.myJson = REZOLVA_PENSIUNE;
            ecranPensiune.backString = @"Harta";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            //            [self presentViewController:ecranPensiune animated:NO completion:nil ];
            [self.navigationController pushViewController:ecranPensiune animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                [SELFINBLOCK hideLupa];
                EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
                ecranPensiune.myJson = REZOLVA_PENSIUNE;
                ecranPensiune.backString = @"Harta";
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranPensiune animated:NO];
            }
            else{
                [SELFINBLOCK hideLupa];
                EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
                ecranPensiune.myJson = REZOLVA_PENSIUNE;
                ecranPensiune.backString = @"Harta";
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranPensiune animated:NO];
            }
            
        }
        
    }
}

-(void) pushSearchButton{
    [Lupa sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)pushFiltreButton{
    [butonMeniuSus sendActionsForControlEvents:UIControlEventTouchUpInside];
}


//ecran pensiune
-(IBAction)butonPensiuneSelectat:(id)sender {
    [self hideLupa];
    EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
    [self.navigationController presentViewController:ecranPensiune animated:YES completion:nil ];
    //put back icon I think
    
}
-(void)KillerMode {
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
         Ecran4Filtre *filtreselect=[[Ecran4Filtre alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
       [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:filtreselect animated:NO];
    }else{
        //DO Landscape
         Ecran4Filtre *filtreselect=[[Ecran4Filtre alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
         [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:filtreselect animated:NO];
    }
    
}
////////////////// ECRAN 4 FILTRE  <- butonMeniuSus //////////////////
-(IBAction)butonFiltre:(id)sender {
    //    butonMeniuSus.selected = !butonMeniuSus.selected;
    // if (butonMeniuSus.selected) {
    [self hideLupa];
    [self KillerMode];
    
}


////////////////// ELEMENTE SI METODE LOCATIE  //////////////////
//// ADD GESTURE BOOL
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
//    (UIGestureRecognizer *)otherGestureRecognizer {
//        if ([gestureRecognizer.view isKindOfClass:[CustomPinAnnotationView class]])    {
//
//            [self goToMarker];
//            //ComNSLog (@"yes");
////            //ComNSLog (Obj class];
//            return YES;  // return YES so that the tapGestureRecognizer can deal with the tap and resign first responder
//        }
//        else
//        {
//            //ComNSLog (@"not of this kind");
//            return NO;  // return NO so that the touch is sent up the responder chain for the map view to deal with it
//        }
//
//
//    return YES;
//}



//-(void)disclosureTapped {
//    EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
//    [self.navigationController presentModalViewController:ecranPensiune animated:YES ];
//}

////////////////// ELEMENTE SI METODE CAUTARE  //////////////////

-(IBAction)ShowLupa:(id)sender {
    Lupa.selected = !Lupa.selected;
    if (Lupa.selected) {
        //buton curata text si inchide search
        UIButton *curataInchide = [UIButton buttonWithType:UIButtonTypeCustom];
        [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateNormal];
        [curataInchide setBackgroundImage:[UIImage imageNamed:@"smallclose.png"] forState:UIControlStateSelected];
        
        [curataInchide addTarget:self
                          action:@selector(verificaSearch)
                forControlEvents:UIControlEventTouchUpInside];
        curataInchide.frame = CGRectMake(0, 6, 18, 18);
        [self.view bringSubviewToFront:searchBar];
        searchBar.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
        [searchBar setRightView:curataInchide];
        searchBar.hidden=NO;
        ButonMareAscuns.hidden=NO;
        [self textFieldDidChange1:searchBar];
        table.hidden=NO;
    }   else {
        [self hideLupa];
    }
}
-(IBAction)AscundeSearch:(id)sender {
    [self hideLupa];
}
-(void)hideLupa{
    Lupa.selected= NO;
    searchBar.hidden=YES;
    [searchBar resignFirstResponder];
    searchBar.placeholder=searchBarString;
    isFiltered=false;
    [self textFieldDidChange1:searchBar];
    [searchBar resignFirstResponder];
    ButonMareAscuns.hidden=YES;
    searchResults = toateRezultatele;
    table.hidden=YES;
    [self.table setNeedsDisplay];
    [self.table reloadData];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //ComNSLog(@"begin editing---%@",textField.text);
    textField.text = @"";
    textField.placeholder = searchBarString;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //ComNSLog(@"end editing---%@",textField.text);
    if([textField.text isEqualToString:@""]){
        textField.placeholder = searchBarString;
    }
    
}
-(void)curataText{
    [searchBar becomeFirstResponder];
    searchBar.text = @"";
}
-(void)textFieldDidChange1 :(UITextField *)textfield
{
    cateSearch =searchBar.text.length;
    [searchBar becomeFirstResponder];
    if([textfield.text isEqualToString:searchBarString]){
        [self curataText];
    }
    
    //ComNSLog(@"searchBar.text.length %i",searchBar.text.length);
   if(searchBar.text.length ==0)
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
          }
    else
    {
         [self searchBartextlengthJ];
      }
}
-(void)searchBartextlengthJ {
    __block id SELFINBLOCK = self;
    [searchBar becomeFirstResponder];
    isFiltered = true;//    //ComNSLog(@"JJJ");
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(d_group, bg_queue, ^{
        [SELFINBLOCK PROCESEAZA_SUGESTII:searchBar.text];
    });
    //   NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"nume", searchText];//keySelected is NSString itself
    //   NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"nume", searchText];//keySelected is NSString itself
    //   searchResults = [NSArray arrayWithArray:[toateRezultatele filteredArrayUsingPredicate:predicateString]];
    //   searchResults = toateRezultatele;
    searchResults=toateRezultatele;
    if(searchResults.count >3) {
        searchResults = toateRezultatele;
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * 3)];
        [self.table reloadData];
        [self.table setNeedsDisplay];
    }
    else {
        [[self table] setFrame:CGRectMake(table.frame.origin.x,table.frame.origin.y, table.frame.size.width, 50 * searchResults.count)];
        [self.table reloadData];
        [self.table setNeedsDisplay];
    }
    //ComNSLog(@"filt:: %@", searchResults);
}



////////////////// TABEL CAUTARE
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenericCell"];
    //    NSUInteger row=indexPath.row;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    //pt toate mai putin pensiune unde are mai mult text
    UILabel *lblMainLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 14, 125, 25)];
    lblMainLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:11.0f];
    lblMainLabel.backgroundColor = [UIColor clearColor];
    lblMainLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1];
    lblMainLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [lblMainLabel setTextAlignment:NSTextAlignmentRight];
    //pt pensiune
    UILabel *textprincipal = [[UILabel alloc] init];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        textprincipal = [[UILabel alloc]initWithFrame:CGRectMake(10,2, 165, 48)];
    } else {
        //DO Landscape
        textprincipal = [[UILabel alloc]initWithFrame:CGRectMake(4,2, 165, 48)];
    }
    textprincipal.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    textprincipal.backgroundColor = [UIColor clearColor];
    textprincipal.textColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1];
    textprincipal.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [textprincipal setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *lblMainLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 14, 125, 25)];
    lblMainLabel2.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
    lblMainLabel2.backgroundColor = [UIColor clearColor];
    lblMainLabel2.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    lblMainLabel2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [lblMainLabel2 setTextAlignment:NSTextAlignmentRight];
    if(isFiltered) {
        NSDictionary *afisareToate= [searchResults objectAtIndex: indexPath.row];
        //            categorie = 2;
        //            id = 5805;
        //            nume = Sanda;
        //            numeLocalitate = "Targu Mures";
        //            pret = "70 RON/Camera dubla";
        //            tip = pensiune;
        //            tipUnitate = Pensiunea;
        NSString *tip = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"tip"] ];
        if([tip isEqualToString:@"localitate"]) {
            NSString *nrPensiuni = [NSString stringWithFormat:@"%@", [afisareToate objectForKey:@"nrPensiuni"]];
            NSString *nrObiective = [NSString stringWithFormat:@"%@", [afisareToate objectForKey:@"nrObiective"]];
            //ComNSLog(@"nr PENSIUNI ok ? %@",  nrPensiuni);
            //ComNSLog(@"nr OBIECTIVE ok ? %@",  nrObiective);
            
            BOOL egol  = [ self MyStringisEmpty :nrPensiuni];
            if(!egol)
            {
                NSString *titlurow  = [[NSString alloc]init];
                if(nrPensiuni.intValue ==1) {
                    titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
                    lblMainLabel.text =[NSString stringWithFormat:@"%@ pensiune",[afisareToate objectForKey:@"nrPensiuni"] ];
                }
                else if(nrPensiuni.intValue >1) {
                    titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
                    lblMainLabel.text =[NSString stringWithFormat:@"%@ pensiuni",[afisareToate objectForKey:@"nrPensiuni"] ];
                }
                textprincipal.text = titlurow;
                [cell.contentView addSubview:textprincipal];
                [cell.contentView addSubview:lblMainLabel];
                
            }
            else {
                egol  = [ self MyStringisEmpty :nrObiective];
                if(!egol) {
                    NSString *titlurow  = [[NSString alloc]init];
                    if(nrObiective.intValue ==1) {
                        titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
                        lblMainLabel.text =[NSString stringWithFormat:@"%@ obiectiv",[afisareToate objectForKey:@"nrObiective"] ];
                    } else if (nrObiective.intValue >1) {
                        titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
                        lblMainLabel.text =[NSString stringWithFormat:@"%@ obiective",[afisareToate objectForKey:@"nrObiective"] ];
                    }
                    textprincipal.text = titlurow;
                    [cell.contentView addSubview:textprincipal];
                    [cell.contentView addSubview:lblMainLabel];
                }
            }
        } else  if([tip isEqualToString:@"obiectiv"]) {
            
            NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
            lblMainLabel2.text =[NSString stringWithFormat:@"%@"  ,[afisareToate objectForKey:@"numeLocalitate"] ];
            textprincipal.text = titlurow;
            textprincipal.numberOfLines =0;
            textprincipal.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:textprincipal];
            [cell.contentView addSubview:lblMainLabel2];
            
        }  else if([tip isEqualToString:@"pensiune"]) {
            NSString *tarif = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"pret"] ];
            NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"]];
            lblMainLabel2.text = tarif;
            textprincipal.text = titlurow;
            textprincipal.numberOfLines =0;
            textprincipal.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:textprincipal];
            [cell.contentView addSubview:lblMainLabel2];
        }
        else {
            NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"] ];
            cell.textLabel.text = titlurow;
        }
    }
    else   {
        NSDictionary *afisareToate= [toateRezultatele objectAtIndex: indexPath.row];
        NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"] ];
        textprincipal.frame  = CGRectMake(5,2, 260, 48);
        textprincipal.text = titlurow;
        textprincipal.numberOfLines =0;
        textprincipal.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:textprincipal];
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



// http://json.infopensiuni.ro/pensiuni/lista/sugestii/?txt=


-(void)prepara_localitate:(NSString *)localitate {
    //ComNSLog(@"PREGATESTE LOCALITATE");
    NSString *Localitate = localitate;
    NSString* encodedUrl = [Localitate stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
    
    NSString *path_localitate = [[NSString alloc]init];
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *cmd_local = appDelGlobal.CMD_STRING;
    
    if([  cmd_local isEqualToString:CMD_LISTA_PENSIUNI ])
    {
        path_localitate = [NSString stringWithFormat:@"/pensiuni/lista/localitate/?id=%@", encodedUrl];
    } else if([cmd_local isEqualToString:CMD_LISTA_OBIECTIVE ]) {
        path_localitate = [NSString stringWithFormat:@"/obiective/lista/localitate/?id=%@", encodedUrl];
    } else if([cmd_local isEqualToString:CMD_ALL ]) {
        path_localitate = [NSString stringWithFormat:@"/pensiuni/lista/localitate/?id=%@", encodedUrl];
    }
    BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
    if(!verificanet) {
        [self ALERTNOINTERNET];
    } else {
    __block id SELFINBLOCK = self;
    //ComNSLog(@"path_localitate %@",path_localitate);
    MKNetworkOperation *op = [engine operationWithPath:path_localitate
                                                params:nil
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary* rezultat_REQ4 = [completedOperation responseJSON];
        if([self checkDictionary:rezultat_REQ4]){
            //das ist
            if(rezultat_REQ4) {
                if([  cmd_local isEqualToString:CMD_LISTA_PENSIUNI ] ||[cmd_local isEqualToString:CMD_ALL ] ) {
                    //ComNSLog(@"%s DATA incarcare path_localitate %@ ",__func__,rezultat_REQ4);
                    [SELFINBLOCK rezolvaPensiuniIDS:rezultat_REQ4];}
                else if([cmd_local isEqualToString:CMD_LISTA_OBIECTIVE ] ){
                    [SELFINBLOCK rezolvaObiectiveIDS:rezultat_REQ4];}
            }
        }
        else{

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

        
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {

        //ComNSLog(@"%@", error); //show err
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    /////add to the http queue and the request is sent
    [engine enqueueOperation: op];
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        __block id SELFINBLOCK = self;
    long ROWSelectat =indexPath.row;
    if(isFiltered) {
        NSDictionary *afisareToate= [searchResults objectAtIndex: ROWSelectat];
        //ComNSLog(@"ce avem si unde il trimitem%@",afisareToate );
        NSString *tip = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"tip"] ];
        if([tip isEqualToString:@"localitate"]) {
            //            id = 1;
            //            nrPensiuni = 28;
            //            nume = Bucuresti;
            //            tip = localitate;
            NSString *titlurow = [NSString stringWithFormat:@"%@  %@ pensiuni",[afisareToate objectForKey:@"nume"] ,[afisareToate objectForKey:@"nrPensiuni"] ];
            NSString *LOCALITATEID = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"id"]];
            
            //ComNSLog(@"row tabel filtrat %@",titlurow );
            [self prepara_localitate:LOCALITATEID];
            //prepare the data
        }
        if([tip isEqualToString:@"pensiune"]) {
            NSString *pensiuneID = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"id"]];
             [SELFINBLOCK VerificaAreNet:tip :pensiuneID];
        }
        if([tip isEqualToString:@"obiectiv"]) {
            NSString *obiectivID = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"id"]];
              [SELFINBLOCK VerificaAreNet:tip :obiectivID];
                   }
        if([tip isEqualToString:@"grup_obiective"]) {
            NSArray *obiectiveIDS = [afisareToate objectForKey:@"ids"];
            NSString *obiectiveIDSString = [NSString stringWithFormat:@""];
            obiectiveIDSString = [obiectiveIDS componentsJoinedByString:@","];
                [SELFINBLOCK VerificaAreNet:tip :obiectiveIDSString];
                 }
        if([tip isEqualToString:@"grup_pensiuni"]) {
            NSArray *pensiuniIDS = [afisareToate objectForKey:@"ids"];
            NSString *pensiuniIDSString = [NSString stringWithFormat:@""];
            pensiuniIDSString = [pensiuniIDS componentsJoinedByString:@","];
              [SELFINBLOCK VerificaAreNet:tip :pensiuniIDSString];
        }
     }
    else   {
        NSDictionary *afisareToate= [toateRezultatele objectAtIndex: ROWSelectat];
        NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"] ];
        //ComNSLog(@"row tabel full %@",titlurow );
 
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



-(void)PROCESEAZA_SUGESTII:(NSString*)searchText {
    //ComNSLog(@"PROCESEAZA_SUGESTII");
    NSString *TEXTCAUTARE = searchText;
    NSString* encodedUrl = [TEXTCAUTARE stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    if (TEXTCAUTARE ==nil || TEXTCAUTARE.length ==0 || [TEXTCAUTARE isEqualToString:@""]) {
        [self mesajAlerta:@"Introduceti un text pentru cautare." titluAlerta:@"Atentie"];
    }
    else {
        engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *cmd_local = appDelGlobal.CMD_STRING;
        NSString *path_sugestii = [[NSString alloc]init];
        if([  cmd_local isEqualToString:CMD_LISTA_PENSIUNI ])
        {
            path_sugestii = [NSString stringWithFormat:@"/pensiuni/lista/sugestii/?txt=%@", encodedUrl];
        } else if([cmd_local isEqualToString:CMD_LISTA_OBIECTIVE ]) {
            path_sugestii = [NSString stringWithFormat:@"/obiective/lista/sugestii/?txt=%@", encodedUrl];
        } else if([cmd_local isEqualToString:CMD_ALL ]) {
            path_sugestii = [NSString stringWithFormat:@"/all/lista/sugestii/?txt=%@", encodedUrl];
        }
        //ComNSLog(@"path_sugestii %@",path_sugestii);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
        MKNetworkOperation *op = [engine operationWithPath:path_sugestii
                                                    params:nil
                                                httpMethod:@"GET"];
        __block id SELFINBLOCK = self;
        
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSDictionary* rezultat_REQ3 = [completedOperation responseJSON];
            if(rezultat_REQ3) {
                //            //ComNSLog(@"%s DATA incarcare multe pensiuni initiale %@ ",__func__,rezultat_REQ3);
                NSArray *items = (NSArray *) [rezultat_REQ3 objectForKey:@"results"];
                // reading all the items in the array one by one
                // incarca   toateRezultatele
                toateRezultatele =[[NSMutableArray alloc]init];
                for (id item in items) {
                        [toateRezultatele addObject:item];
                }
                //DOAR 3 rezultate
                NSMutableArray  *toateRezultateleDoar3 =[[NSMutableArray alloc]init];
                for(int i=0;i<toateRezultatele.count;i++) {
                    if (i<3){    id obj = [toateRezultatele objectAtIndex:i];
                        [toateRezultateleDoar3 addObject:obj];
                    }
                }
                toateRezultatele = toateRezultateleDoar3;
                
                //ComNSLog(@"toate rezultatele %@", toateRezultatele);
                [SELFINBLOCK actualizeazaViewTabel];
            
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            //ComNSLog(@"%@", error); //show err
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        /////add to the http queue and the request is sent
        [engine enqueueOperation: op];
    }
    }
}
-(void) actualizeazaViewTabel {
    searchResults = toateRezultatele;
    [self.IndicatorIncarcaDate stopAnimating];
    self.IndicatorIncarcaDate.hidden=YES;
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



//    http://json.infopensiuni.ro/all/markers/bounds/?swlat=47.563554&swlng=25.960264&nelat=47.563554&nelng=25.960264&stele=2,1,0,4,5&faraCategorii=54,59,71,47,57,56,52,51,67,53,60,44,41,48,49,66,50,40,62,61,45,43&pretMin=25&pretMax=690

////////////////// Preia harta PENSIUNI OBIECTIVE ALL ////////////////// rezultat_REQ2 -> default pensiuni
// WEBSERVICE_MARKERS_PENSIUNI  @"/pensiuni/markers/bounds/?" // [are bifate pensiuni]
-(void)PROCESEAZA_CMD :(NSString *)margini :(NSString*)stringPentruServer :(NSString*)cmd_local{
    //   margini = [self MARGINIMAP];
//    localizeHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    localizeHUD.labelText = @"Va rugam asteptati";
    //  curata harta
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSMutableArray *LONGANDLAT = (NSMutableArray *)[margini componentsSeparatedByString:@"~"];
    NSMutableArray *LONGANDLAT_NE = (NSMutableArray *)[LONGANDLAT[0] componentsSeparatedByString:@","];
    NSMutableArray *LONGANDLAT_SW = (NSMutableArray *)[LONGANDLAT[1] componentsSeparatedByString:@","];
    if(LONGANDLAT.count ==2) {
        //ComNSLog(@"margini---%@",margini);
        
        
        NSString *neLat= [NSString stringWithFormat:@"%@", [LONGANDLAT_NE objectAtIndex:0]];
        NSString *neLng= [NSString stringWithFormat:@"%@", [LONGANDLAT_NE objectAtIndex:1]];
        NSString *swLat= [NSString stringWithFormat:@"%@", [LONGANDLAT_SW objectAtIndex:0]];
        NSString *swLng= [NSString stringWithFormat:@"%@", [LONGANDLAT_SW objectAtIndex:1]];
        NSString *BOUNDS = [NSString stringWithFormat:@"&swLat=%@&swLng=%@&neLat=%@&neLng=%@",swLat,swLng, neLat, neLng];
        
        
        //ComNSLog(@"neLat:   %@",neLat);
        //ComNSLog(@"neLng:   %@",neLng);
        
        //ComNSLog(@"cmd_local---%@",cmd_local);
        NSString *compus= @"";
        if([  cmd_local isEqualToString:CMD_LISTA_PENSIUNI ])
        {
            compus = [NSString stringWithFormat:@"%@%@%@", WEBSERVICE_MARKERS_PENSIUNI,self.stringPentruServer, BOUNDS];
        } else if([cmd_local isEqualToString:CMD_LISTA_OBIECTIVE ]) {
            compus = [NSString stringWithFormat:@"%@%@%@", WEBSERVICE_MARKERS_OBIECTIVE,self.stringPentruServer, BOUNDS];
            //ComNSLog (@"ooobiectiveeee");
        } else if([cmd_local isEqualToString:CMD_ALL ]) {
            compus = [NSString stringWithFormat:@"%@%@%@", WEBSERVICE_MARKERS_ALL,self.stringPentruServer, BOUNDS];
        }
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro%@",compus];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //ComNSLog(@"compus %@", url);
        BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
        if(!verificanet) {
            [self ALERTNOINTERNET];
        } else {
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        __block id SELFINBLOCK = self;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setDelegate:self];
        
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *rezultat_REQ2 = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:nil];
            //ComNSLog(@"Response: %@", responseString);
            
            [SELFINBLOCK POPULEAZA_HARTA:rezultat_REQ2];
            
            /////////// fixeaza harta pe coordonate
            MKCoordinateRegion region;
            CLLocationCoordinate2D  FizeazaHarta = CLLocationCoordinate2DMake((neLat.floatValue + swLat.floatValue)/2,(neLng.floatValue + swLng.floatValue)/2);
            region.center = FizeazaHarta;
            MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
            region.span = span;
            //muta harta fara zoom ->are deja zoom 14
            //ComNSLog(@"center coordinate (proceseaza cmd):   %f,%f",FizeazaHarta.latitude,FizeazaHarta.longitude);
            //           [mapView setCenterCoordinate:FizeazaHarta zoomLevel:ZOOM_LEVEL_14 animated:YES];
            //JMOD FIX            [mapView setCenterCoordinate:FizeazaHarta animated:YES];
            //            [mapView setRegion:region];
        }];
        
        [request setFailedBlock:^{
           
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [request startAsynchronous];
    }
    }
}



-(void)endRequestWithConnectionError:(NSString*)data{
    [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
    
}


///BUTOANE



/////alerte
- (void)POPULEAZA_HARTA:(NSDictionary *)rezultat_REQ2 {
    //curata harta
    
    NSMutableArray * annotationsToRemove = [ mapView.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:mapView.userLocation ] ;
    
    if ([annotationsToRemove count] > 0)
        [ mapView removeAnnotations:annotationsToRemove ] ;
    
    //    for(id key in rezultat_REQ2) {
    //        id value = [rezultat_REQ2 objectForKey:key];
    //       // //ComNSLog(@"VALS %@",value);
    //    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Se incarca";
    
    //ComNSLog(@"populeaza harta");
    NSArray *items = (NSArray *) [rezultat_REQ2 objectForKey:@"results"];
    //ComNSLog(@"MULTE %lui", (unsigned long)items.count);
    //    NSMutableArray *grup_obiective = [[NSMutableArray alloc]init];
    //    NSMutableArray *obiectiv = [[NSMutableArray alloc]init];
    //    NSMutableArray *grup_pensiuni = [[NSMutableArray alloc]init];
    //    NSMutableArray *pensiune = [[NSMutableArray alloc]init];
    annoations = [[NSMutableArray alloc]init];
    pins = [[NSMutableArray alloc] init];
    FullAnnotations= [[NSMutableArray alloc]init];
    for (id item in items) {
        //        NSString *tipRaspuns = [itemX objectForKey:@"tipRaspuns"];
        //        if([ tipRaspuns isEqualToString:@"grup_obiective"]) {
        //            [grup_obiective addObject:item];
        //        } else   if([ tipRaspuns isEqualToString:@"obiectiv"]) {
        //            [obiectiv addObject:item];
        //        } else   if([ tipRaspuns isEqualToString:@"grup_pensiuni"]) {
        //            [grup_pensiuni addObject:item];
        //        }  else   if([ tipRaspuns isEqualToString:@"pensiune"]) {
        //            [pensiune addObject:item];
        //        }
        
        [FullAnnotations addObject:item];
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    for(int i=0; i< FullAnnotations.count; i++) {
        NSDictionary *itemX = [FullAnnotations objectAtIndex:i];
        MapAnnotation *capeCanaveral = [MapAnnotation new];
        //important
        capeCanaveral.idAnn = i;
        capeCanaveral.coordinate = (CLLocationCoordinate2D){[[itemX objectForKey:@"lat"] floatValue], [[itemX objectForKey:@"lng"] floatValue]};
        
        
        NSString *titlu = [[NSString alloc] init];
        NSString *subtitlu = [[NSString alloc] init];
        capeCanaveral.title = titlu;
        capeCanaveral.subtitle =subtitlu;
        CustomPinAnnotationView *bottomPin = [[CustomPinAnnotationView alloc] initWithAnnotation:capeCanaveral reuseIdentifier:@""];
        NSString *tipRaspuns = [itemX objectForKey:@"tipRaspuns"];
        if([ tipRaspuns isEqualToString:@"grup_obiective"] || [ tipRaspuns isEqualToString:@"obiectiv"]) {
            bottomPin.image = [UIImage imageNamed:@"indicator-portocaliu.png"];
        }
        else   if([ tipRaspuns isEqualToString:@"grup_pensiuni"]||[ tipRaspuns isEqualToString:@"pensiune"]) {
            bottomPin.image = [UIImage imageNamed:@"red-pin.png"];
        }
        
        bottomPin.idAnn = i;
        [pins addObject:bottomPin];
        [mapView addAnnotation:capeCanaveral];
    }
    if(FullAnnotations.count !=0 ){
        //ComNSLog(@"FullAnnotations at 0  %@", FullAnnotations[0] );
    }
    //ComNSLog(@"filtre gata ");
    //ComNSLog(@"aufviedersehen");
    //                [self selfMAPREFRESH];
    [self.IndicatorIncarcaDate stopAnimating];
    self.IndicatorIncarcaDate.hidden=YES;
    //   CLLocationCoordinate2D center = mapView.centerCoordinate;
    ///   mapView.centerCoordinate = center;
    [mapView setNeedsDisplay];
    //     AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //     appDelGlobal.FullAnnotations = self.FullAnnotations;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}





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
///
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
    BOOL verificanet =[self VERIFICARE_REQUEST_ARE_NET];
    if(!verificanet) {
        [self ALERTNOINTERNET];
    } else {
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if(data ) {
            [self performSelectorOnMainThread:@selector(fetchedDataGoogle:) withObject:data waitUntilDone:YES];
        }
    });
    }
}

- (void)fetchedDataGoogle:(NSData *)responseData {
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
//////
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
//        if([place isKindOfClass:[NSDictionary class]]){
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
//            if([geo isKindOfClass:[NSDictionary class]]) {
        
        //Get our name and address info for adding to a pin.
        //not used to
        //        NSString *name=[place objectForKey:@"name"];
        //        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
//         if([loc isKindOfClass:[NSDictionary class]]) {
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        //ComNSLog(@"placeCoord.latitude    placeCoord.longitude %f %f", placeCoord.latitude ,placeCoord.longitude);
       
        if (43.3707 < [[loc objectForKey:@"lat"] doubleValue] &&  [[loc objectForKey:@"lat"] doubleValue]<48.1506  && 20.1544 <[[loc objectForKey:@"lng"] doubleValue] && [[loc objectForKey:@"lng"] doubleValue] <29.4124) {
            //            Locatia e in Romania
            NSString *result = nil;
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *cmd_local = appDelGlobal.CMD_STRING;
            self.stringPentruServer = appDelGlobal.stringPentruServer;
                    result =[NSString stringWithFormat:@"%f,%f", placeCoord.latitude ,placeCoord.longitude];
            
            /////////// fixeaza harta pe coordonate
            MKCoordinateRegion region;
            CLLocationCoordinate2D  FizeazaHarta = CLLocationCoordinate2DMake(placeCoord.latitude,placeCoord.longitude);
            region.center = FizeazaHarta;
            MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
            region.span = span;
            //muta harta fara zoom ->are deja zoom 14
            //ComNSLog(@"center coordinate (proceseaza cmd):   %f,%f",FizeazaHarta.latitude,FizeazaHarta.longitude);
            //           [mapView setCenterCoordinate:FizeazaHarta zoomLevel:ZOOM_LEVEL_14 animated:YES];
            [mapView setCenterCoordinate:FizeazaHarta animated:YES];
            [mapView setRegion:region];
            
            [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer :cmd_local];
            
            
            //ComNSLog(@"google rezult %@",result);
            
            [self hideLupa];
        }
//         }
//            }
//        }
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
        
    }
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(BOOL)VERIFICARE_REQUEST_ARE_NET {
    
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            return YES;
            break;
            }
        case ReachableViaWiFi:
            {
                return YES;
                break;
            }
        case NotReachable:
            {
                return NO;
                break;
            }
     }
}

-(bool)checkDictionary:(NSDictionary *)dict{
    //ComNSLog(@"class:  %@",[dict class]);
    if(dict == nil || [dict class] == [NSNull class] || ![dict isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    
    return  YES;
}

-(void) ALERTNOINTERNET {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void) VerificaAreNet :(NSString *)cePrimeste :(NSString *)trimiteMaiDeparte {
    BOOL egol1  = [ self MyStringisEmpty :cePrimeste];
    BOOL egol2  = [ self MyStringisEmpty :trimiteMaiDeparte];
      __block id SELFINBLOCK = self;
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
      switch (netStatus)
    {
        case ReachableViaWWAN:
        {
    if(!egol1 && !egol2) {
        if([ cePrimeste isEqualToString:@"grup_obiective"]) {

            [SELFINBLOCK pregatesteObiectiveIDS:trimiteMaiDeparte];
        } else  if([ cePrimeste isEqualToString:@"obiectiv"]) {
            [SELFINBLOCK pregatesteObiectiv:trimiteMaiDeparte];
        } else  if([ cePrimeste isEqualToString:@"grup_pensiuni"]) {
            [SELFINBLOCK pregatestePensiuniIDS:trimiteMaiDeparte];
        } else  if([ cePrimeste isEqualToString:@"pensiune"]) {
            [SELFINBLOCK pregatestePensiune:trimiteMaiDeparte];
        }

             break;
    }
        case ReachableViaWiFi:
        {
            if(!egol1 && !egol2) {
                if([ cePrimeste isEqualToString:@"grup_obiective"]) {
                    [SELFINBLOCK pregatesteObiectiveIDS:trimiteMaiDeparte];
                } else  if([ cePrimeste isEqualToString:@"obiectiv"]) {
                    [SELFINBLOCK pregatesteObiectiv:trimiteMaiDeparte];
                } else  if([ cePrimeste isEqualToString:@"grup_pensiuni"]) {
                    [SELFINBLOCK pregatestePensiuniIDS:trimiteMaiDeparte];
                } else  if([ cePrimeste isEqualToString:@"pensiune"]) {
                    [SELFINBLOCK pregatestePensiune:trimiteMaiDeparte];
                }
            }
           
            break;
        }
        case NotReachable:
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }
    }
}
@end


@implementation MapAnnotation
@end

@implementation CustomPinAnnotationView
@synthesize calloutView;
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    return [super hitTest:point withEvent:event];
}
@end


////garbage
//- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
//{
//
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
//
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
//    CLLocationCoordinate2D touchMapCoordinate =
//    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//
//    point.coordinate = touchMapCoordinate;
//    point.title = @"Pensiune x";
//    point.subtitle = @"I'm here!!!";
//
//
//    CLLocationCoordinate2D topLeft, bottomRight;
//    topLeft = [mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:mapView];
//    CGPoint pointBottomRight = CGPointMake(mapView.frame.size.width, mapView.frame.size.height);
//    bottomRight = [mapView convertPoint:pointBottomRight toCoordinateFromView:mapView];
//    MKPointAnnotation *pointBottom = [[MKPointAnnotation alloc] init];
//    pointBottom.coordinate = topLeft;
//    pointBottom.title = @"Pensiune y";
//    pointBottom.subtitle = @"bottom point!!!";
//    [self.mapView addAnnotation:pointBottom];
//
//    MKPointAnnotation *pointTop= [[MKPointAnnotation alloc] init];
//    pointTop.coordinate = bottomRight;
//    pointTop.title = @"Pensiune zzzz";
//    pointTop.subtitle = @"Top point!!!";
//    [self.mapView addAnnotation:pointTop];
//    [self.mapView addAnnotation:point];
//
//    //    NSMutableArray *annotationArray = [[NSMutableArray alloc]init];
//    //    [annotationArray addObject:pointBottom];
//    //        [annotationArray addObject:pointTop];
//    //     [annotationArray addObject:point];
//    //      [mapView setSelectedAnnotations:annotationArray];
//}
//
// //    [self addGestureRecogniserToMapView];
//- (void)addGestureRecogniserToMapView{
//
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
//                                          initWithTarget:self action:@selector(addPinToMap:)];
//    lpgr.minimumPressDuration = 0.5; //
//    [self.mapView addGestureRecognizer:lpgr];
//
//}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation

//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}


//                    UIImage *pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:poza]]];



//    //ComNSLog(@"harta load");
//    //rezultat_REQ2
//    NSString *REQ2_path =[NSString stringWithFormat:@"http://%@",request1_url];
//    //ComNSLog(@" userinfo_path_feedback %@ ",REQ2_path);
//http://json.infopensiuni.ro/pensiuni/markers/bounds/?swLat=47.563554&swLng=25.960264&neLat=47.563554&neLng=25.960264&stele=0,1,2,3,4,5&pretMin=45&pretMax=280
//      engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
//     MKNetworkOperation *op = [engine operationWithPath:@"/app_cr/init/?id=myx1j3"
//                                                 params:nil
//                                             httpMethod:@"GET"];
//http://dev3.activesoft.ro/~cristian/cr/?x=1
//cristi
//    engine=[[MKNetworkEngine alloc] initWithHostName:@"dev3.activesoft.ro" customHeaderFields:nil];
//    MKNetworkOperation *op = [engine operationWithPath:@"/~cristian/cr/?x=1"
//                                                params:nil
//                                            httpMethod:@"GET"];
//
//    http://json.infopensiuni.ro/all/markers/bounds/?swlat=47.563554&swlng=25.960264&nelat=47.563554&nelng=25.960264&stele=4,5&pretMin=45&pretMax=280
//http://json.infopensiuni.ro/pensiuni/markers/bounds/?swlat=47.563554&swlng=25.960264&nelat=47.563554&nelng=25.960264&stele=4,5&pretMin=45&pretMax=280
//    engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
//    MKNetworkOperation *op = [engine operationWithPath:@"/pensiuni/markers/bounds/?swlat=44.4409904&swlng=26.151350&nelat=44.45&nelng=26.16&stele=4,5&pretMin=45&pretMax=280"
//                                              params:nil
////                                               httpMethod:@"GET"];
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@","];
//    //   //ComNSLog(@"pin map");
//    if(pinView == nil)
//    {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
//
//        pinView.animatesDrop = YES;
//        pinView.canShowCallout = YES;
//        //
//        //        UIImage *image = [UIImage imageNamed:@"ann.png"];
//        //
//        //        CGRect resizeRect;
//        //
//        //        resizeRect.size = image.size;
//        //
//        //        CGSize maxSize = CGRectInset(self.view.bounds,
//        //                                     [self.mapView annotationPadding],
//        //                                     [self.mapView  annotationPadding]).size;
//        //        maxSize.height -= self.navigationController.navigationBar.frame.size.height + [self.mapView calloutHeight];
//        //        if (resizeRect.size.width > maxSize.width)
//        //            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
//        //        if (resizeRect.size.height > maxSize.height)
//        //            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
//        //
//        //        resizeRect.origin = (CGPoint){0.0f, 0.0f};
//        //
//        //        UIGraphicsBeginImageContext(resizeRect.size);
//        //        [image drawInRect:resizeRect];
//        //        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//        //        UIGraphicsEndImageContext();
//        //
//        //        pinView.image = resizedImage;
//        //        pinView.opaque = NO;
//
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        //        [rightButton addTarget:self
//        //                        action:@selector(showDetails:)
//        //              forControlEvents:UIControlEventTouchUpInside];
//        pinView.rightCalloutAccessoryView = rightButton;
//
//        if (annotation == self.mapView.userLocation)
//        {
//
//            return nil;
//        }
//        return pinView;
//
//    }
//    else
//    {
//
//        pinView.annotation = annotation;
//    }
//
//    return pinView;
//
//}



//        //ComNSLog(@"compus %@", compus);
//        engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
//        MKNetworkOperation *op = [engine operationWithPath:compus
//                                                    params:nil
//                                                httpMethod:@"GET"];
//        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//            NSDictionary* rezultat_REQ2 = [completedOperation responseJSON];
//            if(rezultat_REQ2) {
//                //    //ComNSLog(@"%s DATA incarcare harta initiala %@ ",__func__,rezultat_REQ2);
//                [self populeaza_harta:rezultat_REQ2];
//            }
//        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//            //ComNSLog(@"%@", error); //show err
//             [self endRequestWithConnectionError:@"eroare"];
//
//        }];
//        /////add to the http queue and the request is sent
//        [engine enqueueOperation: op];
//    }
//}
//List all fonts on iPhone
//for (NSString* famName in [UIFont familyNames]) {
//    //ComNSLog(@"Family name: %@",famName);
//    for (NSString* fontName in [UIFont fontNamesForFamilyName:famName]) {
//        //ComNSLog(@" Font name: %@\n", fontName);
//    }
//}

//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];

//    UIImage *pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.infopensiuni.ro/poze/uc/thumbs/32427.JPG"]]];
//    //        imgView.image = [UIImage imageNamed: [MeniuUserSigle objectAtIndex:indexPath.row]];
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    imgView.clipsToBounds = YES;
//    cell.imageView.image = imgView.image;
//    {
//        categorie = 3;
//        foto = "http://www.infopensiuni.ro/poze/uc/thumbs/38113.JPG";
//        id = 1984;
//        nume = "Alba ca Zapada";
//        numeText = "Vila Alba ca Zapada";
//        obiectiv =     {
//            durataMin = 3;
//            mers = pieton;
//            nume = "Vila Retezat (Casa Anastasie Simu) Sinaia";
//            text = "3 min pe jos";
//        };
//        tarif =     {
//            icon = 2pers;
//            moneda = RON;
//            suma = 70;
//            tc = 1;
//            text = "70 RON/noapte";
//            tip = noapte;
//        };
//        tip = Vila;
//    }

//        cell.textLabel.text =[MeniuUserTitle objectAtIndex:indexPath.row];
//- (IBAction)decodeButton:(id)sender {
//    //ComNSLog(@"aici");
//    if (segmentedControl.selectedSegmentIndex == 0) {
//        /*   self.HIDDENview.hidden =NO;
//         //ComNSLog(@"%@%s", @"0", __func__);
//         [Animations slideinFromLeft: HIDDENview animTime:1.0];
//         //      [ HIDDENview setFrame:self.view.bounds];
//         [ HIDDENview setFrame: CGRectMake(0,250, 320, 377)];
//         AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//         NSMutableArray *_SELECTIEStelePensiuni = appDelGlobal.SELECTIEStelePensiuni;
//         //ComNSLog(@"SELECTIEStelePensiuni divers dupa alegeri %@",_SELECTIEStelePensiuni); // divers
//         } else if(segmentedControl.selectedSegmentIndex == 1) {
//         //ComNSLog(@"%@%s", @"1", __func__);
//         [Animations slideinFromRight: HIDDENview animeTime:2.9];
//         [ HIDDENview setFrame: CGRectMake(0,250, 320, 377)];
//         self.HIDDENview.hidden =NO;*/
//    }
//}
//    if([primaIntrare isEqualToString:@""]) {
//        NSString *stareLogin =@"primaIntrareInappunicL5YYNMwYRYzNDhNYOmF0ZMwtiDQN1khg2VDTzk3IGNCt0mTm";
//        [defaults setObject:stareLogin forKey:@"CazareRomania.ro.stareLogin"];
//
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        //Centrul Romaniei 45°48'21, 6" N / 24°59'17, 6"
//        [self goLocationCENTRU];
//        //ComNSLog(@"prima intrare %@", primaIntrare);
//        //ComNSLog(@"%s",__func__);
//         }
//Create a new annotiation.
// MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
//ROMANIA SPECIFIC LIMITS
//       lat 43.3707 48.1506
//       lng 20.1544 29.4124
// [mapView addAnnotation:placeObject];
//        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        self.stringPentruServer = appDelGlobal.stringPentruServer;
//
//
//
//        if(self.stringPentruServer.length ==0 && appDelGlobal.CMD_STRING.length ==0){
//            self.stringPentruServer = @"&stele=0,1,2,3,4,5";
//            appDelGlobal.CMD_STRING =CMD_LISTA_PENSIUNI;
//            [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:CMD_LISTA_PENSIUNI];
//        } else {
//
//            [self PROCESEAZA_CMD:[self MARGINIMAP] :self.stringPentruServer:appDelGlobal.CMD_STRING];
//        }
//    }

//        categorie = 3;
//        id = 1555;
//        nume = "Vila 10 - Predeal";
//        numeLocalitate = Predeal;
//        pret = "220 RON/Camera dubla";
//        tip = pensiune;
//        tipUnitate = Pensiunea;
//        else {
//            NSString *titlurow = [NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"nume"] ];
//
//            //ComNSLog(@"row tabel filtrat %@",titlurow );
//        }

//            //ComNSLog(@"%s DATA incarcare multe pensiuni initiale %@ ",__func__,rezultat_REQ3);
//                NSArray *items = (NSArray *) [rezultat_REQ4 objectForKey:@"results"];
// reading all the items in the array one by one
// incarca   toateRezultatele
//                toateRezultatele =[[NSMutableArray alloc]init];
//                for (id item in items) {
//                    // if the item is NSDictionary (in this case ... different json file will probably have a different class)
//                    //    //ComNSLog(@"ITEM multe.... %@", item);
//                    [toateRezultatele addObject:item];
//                }
//                //ComNSLog(@"toate rezultatele %@", toateRezultatele);
//                [self.table reloadData];
//                [self.IndicatorIncarcaDate stopAnimating];
//                self.IndicatorIncarcaDate.hidden=YES;
//                [self.table reloadData];
//                [self.table setNeedsDisplay];

/* if(self.stringPentruServer.length ==0){
 self.stringPentruServer = @"&stele=0,1,2,3,4,5";
 }*/

//         for(int i=0; i< [obiectiveIDS count]-1; i++){
//             obiectiveIDSString = [obiectiveIDSString stringByAppendingFormat:@"%@,",obiectiveIDS[i]];
//         }
//         obiectiveIDSString = [obiectiveIDSString stringByAppendingFormat:@"%@",obiectiveIDS[[obiectiveIDS count] -1]];


/////J BONUS
////// fix map inside USA (example)
//-(void) gotoAmerica {
//    // lower-left co-ordinate of USA MAP
//    CLLocationCoordinate2D lowerLeftCoOrd = CLLocationCoordinate2DMake(21.652538062803, -127.620375523875420);
//    // create a map-point using lower-left co-ordinate.
//    MKMapPoint lowerLeft = MKMapPointForCoordinate(lowerLeftCoOrd);
//    // upper-right co-ordinate of USA Map
//    CLLocationCoordinate2D upperRightCoOrd = CLLocationCoordinate2DMake(50.406626367301044, -66.517937876818);
//    // create a map-point using upper-right co-ordinate
//    MKMapPoint upperRight = MKMapPointForCoordinate(upperRightCoOrd);
//    // create a map-rect using both co-ordinates as follows.
//    MKMapRect mapRect = MKMapRectMake(lowerLeft.x, upperRight.y, upperRight.x - lowerLeft.x, lowerLeft.y - upperRight.y);
//    // set zoom to rect &amp; you are done.
//    [self.mapView setVisibleMapRect:mapRect animated:YES];
//}
//PARTEA ASTA E HARDCODATA.... JUST IN CASE
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake((48.1506 + 43.3707) / 2.0, (29.4124 + 20.1544) / 2.0), 1000.0, 1000.0);
//    region.span.latitudeDelta = MAX(region.span.latitudeDelta, (48.1506 - 43.3707) * 1.25);
//    region.span.longitudeDelta = MAX(region.span.longitudeDelta, (48.1506 - 29.4124) * 1.25);