//
//  EcranFavoriteViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranFavoriteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EcranLocalizareViewController.h"
#import "AppDelegate.h"
#import "FavoriteTableViewCell.h" //custom cell
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface EcranFavoriteViewController ()

@end

@implementation EcranFavoriteViewController
@synthesize backLabel,backButton,backView,favoritesListTableView,mainScrollView,deleteButton,pensionCoordinate,myJson,pensiuneaSursa,locatieUserSursa,stringSursaRuta,copieFavorite,TITLUECRAN;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getUserLocation {
    //incarca locatie user
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *currentLocation = locationManager.location;
    
    if (currentLocation != nil) {
        locatieUserSursa = [[NSMutableDictionary alloc]init];
        NSString *latPensiune = [[NSString alloc]init];
        NSString *lngPensiune = [[NSString alloc]init];
        latPensiune =[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
        lngPensiune =[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
        [locatieUserSursa setValue:latPensiune forKey:@"lat"];
        [locatieUserSursa setValue:lngPensiune forKey:@"lng"];
        //ComNSLog(@"LOCATIE USER DICTIONAR %@", locatieUserSursa);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [mainScrollView setScrollsToTop:YES];
    [favoritesListTableView setScrollsToTop:NO];
    
    [self getUserLocation];
    self.myJson = myJson;
    self.pensiuneaSursa = pensiuneaSursa;
    pensionCoordinate = CLLocationCoordinate2DMake([myJson[@"gps"][0] floatValue],[myJson[@"gps"][1] floatValue]);
    // Do any additional setup after loading the view from its nib.
    
    [mainScrollView setBounces:YES];
    [favoritesListTableView setScrollEnabled:NO];
    
    deleteButton.layer.cornerRadius = 5.0;
    //    deleteButton.layer.borderWidth = 1.0;
    //    deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    deleteButton.layer.masksToBounds = YES;
    
//    backButton.layer.cornerRadius = 5.0;
    //    backButton.layer.borderWidth = 1.0;
    //    backButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    backButton.layer.masksToBounds = YES;

    
    //    myJson = @{@"favorites" :@[@"Bacau",@"Bucuresti",@"Braila"]};
    //    favoritesArray = myJson[@"favorites"];
    
}
- (void) checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                        message:@"Pentru a putea afisa pensiuni din jurul tau, avem nevoie de locatia ta.\nIncearca din nou dupa ce modifici setarile telefonului."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else { [self checkApplicationHasLocationServicesPermission];}
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
    } else {
        [self getUserLocation];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    favoritesArray = [[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    favoritesArray =[(NSMutableArray*)[defaults objectForKey:@"IstoricLocatii.Cazare.ro"] mutableCopy];
    copieFavorite =[[NSMutableArray alloc]init];
    
    if (favoritesArray.count ==0) {
        //ComNSLog(@"Nu avem istoric");
        
    } else {
        //ComNSLog(@"Avem istoric deja");
        
        favoritesArray =[defaults objectForKey:@"IstoricLocatii.Cazare.ro"];
        copieFavorite =[NSMutableArray arrayWithArray:[[favoritesArray reverseObjectEnumerator] allObjects]];
        //ComNSLog(@"baza copie reverse %@", copieFavorite);
        //ComNSLog(@"istoric %i",copieFavorite.count);
        
    }
    [favoritesListTableView setFrame:CGRectMake(favoritesListTableView.frame.origin.x, favoritesListTableView.frame.origin.y, favoritesListTableView.frame.size.width, 50 * ([copieFavorite count]+1))];
    
    if([[UIScreen mainScreen] bounds].size.height > 480){
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y)];
    }
    else{
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y)];
    }
    
    [self checkLocationServicesTurnedOn];
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.stringSursaRuta  = appDelGlobal.startLocatie;
    //ComNSLog(@"appDelGlobal.startLocatie %@",appDelGlobal.startLocatie);
    TITLUECRAN.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    
    backButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    [favoritesListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //    printButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    //    printButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    printButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    
    [self checkLocationServicesTurnedOn];
    //AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.stringSursaRuta  = appDelGlobal.startLocatie;
    //ComNSLog(@"appDelGlobal.startLocatie %@",appDelGlobal.startLocatie);
//    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y)];
//    }
//    else{
//        if([[UIScreen mainScreen] bounds].size.height > 480){
//            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y)];
//        }
//        else{
//            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y)];
//        }
//    }
    
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
//        
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y+ 275)];
//    }
//    else{
//        if([[UIScreen mainScreen] bounds].size.height > 480){
//            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y+ 100)];
//        }
//        else{
//            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, favoritesListTableView.frame.size.height + favoritesListTableView.frame.origin.y+ 150)];
//        }
//        
//    }
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"FavoritesTableViewCell";
    
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *labelVizibil = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 50)];
  
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] init];
    }
    cell.textLabel.font =[UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    labelVizibil.font =[UIFont fontWithName:@"OpenSans-Light" size:17.5f];

    if(indexPath.row == 0){
       cell.textLabel.textColor =[UIColor colorWithRed:17.0f/255.0f green:167.0f/255.0f blue:171.0f/255.0f alpha:1] ;
        labelVizibil.textColor=[UIColor colorWithRed:17.0f/255.0f green:167.0f/255.0f blue:171.0f/255.0f alpha:1] ;
//         [cell.textLabel setText:@"Locatia mea"];
        labelVizibil.text =@"Locatia mea";
        [cell.contentView addSubview:labelVizibil];
    }
    else{
        //        NSString *descriere =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"description"]];
        //        NSString *referintaUnica =[ NSString stringWithFormat:@"%@",[afisareToate objectForKey:@"reference"]];
        NSMutableDictionary *PREDICTIE = [[NSMutableDictionary alloc]init];
        if(copieFavorite.count >0) {
        PREDICTIE =[copieFavorite objectAtIndex:indexPath.row-1];
        NSString *description = [NSString stringWithFormat:@"%@",[PREDICTIE objectForKey:@"description"] ];
//        cell.textLabel.textColor =[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1] ;
//
      labelVizibil.text =description;
               labelVizibil.textColor =[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1] ;
//              [cell.textLabel setText:description];
              [cell.contentView addSubview:labelVizibil];
        }
    }
 
    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{
    
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

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    //ComNSLog(@"text to measure---%@,%f,%@",textToMesure,width,font);
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 50;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [favoritesArray count] + 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)butonDeletePressed:(id)sender {
    //sterge istoric
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    favoritesArray =[[defaults objectForKey:@"IstoricLocatii.Cazare.ro"] mutableCopy];
    [favoritesArray removeAllObjects];
    [defaults setObject:favoritesArray forKey:@"IstoricLocatii.Cazare.ro"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CGRect frame = self.favoritesListTableView.frame;
    frame.size.height = favoritesArray.count +50;
    [self.mainScrollView setContentOffset:CGPointZero animated:YES];
    [self.favoritesListTableView setFrame:frame];
    [self.favoritesListTableView reloadData];
    [self.favoritesListTableView setNeedsDisplay];
    
    
    
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
            [self prezintaBack];

            break;
        }
        case ReachableViaWiFi:
        {
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
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    long ROWSelectat =indexPath.row;
   
    if( indexPath.row ==0) {
        [self getUserLocation];
        //se trimite la server locatia mea
        //ComNSLog(@"here K");
        //ComNSLog(@"LOCATIE USER DICTIONAR %@", locatieUserSursa);
        if([[self.locatieUserSursa objectForKey:@"lat"]doubleValue ]>0 && [[self.locatieUserSursa objectForKey:@"lng"]doubleValue ]>0) {
            AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelGlobal.userLocatie = locatieUserSursa;
            appDelGlobal.CMD_LOCATIE =@"LocatieUser";
            appDelGlobal.startLocatie = @"Pozitia curenta";
//            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            appDelGlobal.stringPentruGoogle=nil;
            
        }
    } else {
        //salveaza locatia in istoric appdelegate
        NSMutableDictionary *PREDICTIE = [[NSMutableDictionary alloc]init];
        PREDICTIE =[copieFavorite objectAtIndex:indexPath.row-1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * arr = [NSMutableArray arrayWithArray:copieFavorite];
        //ComNSLog(@"arr:  %@",arr);
        //ComNSLog(@"pos:   %d",indexPath.row -1);
        [arr removeObjectAtIndex:indexPath.row -1];
        [arr insertObject:PREDICTIE atIndex:0];
        
        //ComNSLog(@"after:  %@",arr);
        [defaults setObject:[NSMutableArray arrayWithArray:[[arr reverseObjectEnumerator] allObjects]]  forKey:@"IstoricLocatii.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //ComNSLog(@"favorites array:   %@", favoritesArray);
        
        NSString *referintaUnica =[PREDICTIE objectForKey:@"reference"];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.stringPentruGoogle = referintaUnica;
        appDelGlobal.CMD_LOCATIE =@"Altalocatie";
        NSString *DescriereSursa = [NSString stringWithFormat:@"%@",[PREDICTIE objectForKey:@"description"] ];
        appDelGlobal.startLocatie = DescriereSursa;
        //    EcranLocalizareViewController *controller;
        //    controller.myJson = self.myJson;
        //    controller = [[EcranLocalizareViewController alloc] init];
        appDelGlobal.userLocatie = nil;
        [self.navigationController popViewControllerAnimated:YES ];
        
    }
    
    
    
}

@end
