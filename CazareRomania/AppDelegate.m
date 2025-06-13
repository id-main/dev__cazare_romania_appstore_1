//
//  AppDelegate.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import "AppDelegate.h"
#import "NoInternetViewController.h"
#import "NSObject+SBJSON.h"
#import "Reachability.h"
#import "EcranIndicatiiViewController.h"
#import "StartViewController.h"
#import "Flurry.h"

@implementation AppDelegate
@synthesize isLoged, responseData,locationManager,ListaFiltreServer,SELECTIEStelePensiuni,UserTitluriFiltreObiective;
@synthesize  copieF,userPreturi,CMD_STRING,stringPentruServer,stringPentruGoogle,userLocatie,startLocatie,endLocatie,CMD_LOCATIE, areObiective,CMD_GLOBAL_FILTRE;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Flurry setCrashReportingEnabled:NO];
    [Flurry startSession:@"T66S4JHDN5N9B82XBM8J"];
    
    //CMD_STRING =  CMD_LISTA_PENSIUNI;
    // NSLog(@"SERVER URL%@", CMD_STRING);
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *areObiectivex = @"1";
//    [defaults setObject:areObiectivex forKey:@"ObiectiveOn.Cazare.ro"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    copieF =[[NSMutableArray alloc]init];
    [Crashlytics startWithAPIKey:@"2225b6d430e6e8c49ec174c88ca7958760747a2e"];
    // Initialize Reachability
//    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
//    reachability.reachableBlock = ^(Reachability *reachability) {
//        NSLog(@"Network is reachable.");
//    };
//    reachability.unreachableBlock = ^(Reachability *reachability) {
//        NSLog(@"Network is unreachable.");
//    };
//    
//    // Start Monitoring
//    [reachability startNotifier];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    userPreturi = [[NSMutableDictionary alloc]init];
    ListaFiltreServer = [[NSDictionary alloc] init]; //filtre generale
    //user obiective init
    UserTitluriFiltreObiective = [[NSMutableArray alloc]init];
    //selectie filtre pensiuni
    
    NSMutableArray *stelePensiuni =[defaults objectForKey:@"StelePensiuni.Cazare.ro"];
    if(!stelePensiuni) {
        SELECTIEStelePensiuni = [[NSMutableArray  alloc ] init];
        for(int i=0; i<6;i++) {
            NSString *strsimplu = [NSString stringWithFormat:@"%i", i];
            [SELECTIEStelePensiuni addObject:strsimplu];
        }
        [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     [self incearcaNET];
    
    //     [defaults setObject:stareLogin forKey:@"AppComerciant.ro.esteLogat"];
    //    NSString *esteLogat = [[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.esteLogat"];
    //
    //    if([esteLogat isEqualToString:@"esteLogat"]) {
    //        isLoged=true;
    //
    //    }
    //    if(isLoged) {
    //         engine = [[MKNetworkEngine alloc] initWithHostName:base_url customHeaderFields:nil];
    //        ////////////////// Userul e logat  //////////////////
    //               // ii trimitem sesiunea
    //        [self sendLogin];
    //        } else {
    //            [self arataecranLogin];
    //    }
    
    // navigationController.navigationBar.hidden = YES;
    // daca nu are internet il ducem la no internet ->splashscreen
    // daca are internet il ducem la ecranul de start
   
  
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    // post notification that a new location has been found
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newLocationNotif"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:newLocation
                                                                                           forKey:@"newLocationResult"]];
}

-(void)incearcaNET {
    // Add Observer reachabilityNow
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
   //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
                [self performSelector:@selector(areNET) withObject:nil afterDelay:0];
            break;
        }
        case ReachableViaWiFi:
        {
                [self performSelector:@selector(areNET) withObject:nil afterDelay:0];
            break;
        }
        case NotReachable:
        {
            [self splashScreen];

                 break;
        }
            
    }
    
}

-(IBAction)areNET {
    StartViewController *ECRAN1Screen = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:ECRAN1Screen];
    self.window.rootViewController = navigationController;
    navigationController.navigationBar.hidden = YES;
    [self.window makeKeyAndVisible];

}


//NoInternetViewController
-(void)splashScreen {
    NoInternetViewController *nointernetView = [[NoInternetViewController alloc] initWithNibName:@"NoInternetViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:nointernetView];
    self.window.rootViewController = navigationController;
    navigationController.navigationBar.hidden = YES;
    [self.window makeKeyAndVisible];
}
//-(void) arataecranLogin {
//    //aici 1
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *stareLogin =@"nuesteLogat";
//    [defaults setObject:stareLogin forKey:@"CazareRomania.ro.esteLogat"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    ////////////////// Afiseaza  ecran login //////////////////
//    LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:loginView];
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];
//}
//-(void) sendLogin {
//    NSString *EMAILOK = [[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.emailuser"];
//    NSString *PAROLAOK =  [[NSUserDefaults standardUserDefaults] objectForKey: @"CazareRomania.ro.parola"];
//    if(EMAILOK && PAROLAOK) {
//    NSLog(@"%s",__func__);
//    NSArray *keys = [NSArray arrayWithObjects:@"email", @"password",  nil];
//    NSArray *objects = [NSArray arrayWithObjects:EMAILOK,PAROLAOK, nil];
//    NSDictionary *loginDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
//    NSString *loginDictInJSON = [loginDict JSONRepresentation ];
//    NSLog(@"logindict: %@",loginDictInJSON);
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:EMAILOK forKey:@"email"];
//    [dic setObject:PAROLAOK forKey:@"password"];
//    MKNetworkOperation* op = [engine operationWithPath:login_path params:dic httpMethod:@"POST" ssl:NO];
//    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
//    //set completion and error blocks
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSDictionary* result = [completedOperation responseJSON];
//        NSLog(@"%s DATA %@ ",__func__,result);
//        if(result) {
//            NSString *Login_error= [NSString stringWithFormat:@"%@",[result objectForKey:@"error"]];
//            NSString *Login_errorCode=[NSString stringWithFormat:@"%@",[result objectForKey:@"errorCode"]];
//            NSString *Login_errorMessages=[NSString stringWithFormat:@"%@",[result objectForKey:@"errorMessages"]];
//            NSString *Login_message=[NSString stringWithFormat:@"%@",[result objectForKey:@"message"]];
//            NSString *Login_payload=[NSString stringWithFormat:@"%@",[result objectForKey:@"payload"]];
//            NSLog(@"%@ %@ %@ %@ %@", Login_error, Login_errorCode, Login_errorMessages, Login_message, Login_payload);
//            if([Login_error isEqualToString:@"1"]) {
//                if (Login_errorMessages.length ==0 || [Login_errorMessages isEqualToString:@""])
//                    [self mesajAlerta:@"A intervenit o eroare" titluAlerta:@"Eroare"];
//                else  ([self mesajAlerta:Login_errorMessages titluAlerta:@"Eroare"]);
//            } else if([Login_error isEqualToString:@"0"]) {
//                ////////////////// Userul e logat  //////////////////
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSString *stareLogin =@"esteLogat";
//                [defaults setObject:stareLogin forKey:@"CazareRomania.ro.esteLogat"];
//               [[NSUserDefaults standardUserDefaults] synchronize];
//
//                MainboardViewController *mainboardView = [[MainboardViewController alloc] initWithNibName:@"MainboardViewController" bundle:nil];
//                UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:mainboardView];
//                self.window.rootViewController = navigationController;
//                [self.window makeKeyAndVisible];
//            }
//        }
//    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        NSLog(@"%@", error); //show err
//    }];
//    /////add to the http queue and the request is sent
//    [engine enqueueOperation: op];
//    } else {
//        [self arataecranLogin];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tAlerta
                                                    message:mAlerta
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
