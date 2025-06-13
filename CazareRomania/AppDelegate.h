//
//  AppDelegate.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate> {
    NSMutableData* responseData; //ce primeste de la server
    MKNetworkEngine *engine;
    NSDictionary *ListaFiltreServer; //filtrele initale din server
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) bool isLoged;
@property (retain, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) CLLocationManager *locationManager;
-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta;
@property (nonatomic, retain) NSDictionary *ListaFiltreServer;
@property (nonatomic, strong) NSMutableArray *SELECTIEStelePensiuni; //starea  selected -> toate sau ce selecteaza userul
@property (nonatomic, strong) NSMutableArray *UserTitluriFiltreObiective; //ce selecteaza userul
@property (nonatomic, strong) NSMutableDictionary *userPreturi;
@property (nonatomic, retain) NSMutableArray *copieF;
@property (nonatomic, strong) NSMutableArray *globalExcludedSubcats;
@property (nonatomic, strong) NSString *CMD_STRING; // pensiune, obiectiv sau toate
@property (nonatomic, strong) NSString *stringPentruServer;
@property (nonatomic, strong) NSString *stringPentruGoogle;
@property (nonatomic, strong) NSMutableDictionary *userLocatie;
@property (nonatomic, strong) NSString *startLocatie;
@property (nonatomic, strong) NSString *endLocatie;
@property (nonatomic, strong) NSString *itemSelectatpeHarta;
@property (nonatomic,retain) NSMutableArray *FullAnnotations; //copie + id
@property (nonatomic, strong) NSString *CMD_LOCATIE; // sursa sau user locatie
@property (nonatomic) bool areObiective;
@property (nonatomic, strong) NSString *CMD_GLOBAL_FILTRE; // TINE MINTE FILTRELE SETATE DE USER


@end
